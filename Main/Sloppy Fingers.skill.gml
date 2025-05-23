#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Sloppy Fingers.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Sloppy Fingers Icon.png", 1, 8, 8)
script_ref_call(["mod", "lib", "getHooks"], "skill", mod_current);

#define skill_name
	return "Sloppy Fingers";
	
#define skill_text
	return "@wFASTER RELOAD, WORSE ACCURACY#@sEFFECT RAMPS UP WHEN FIRING";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return choose("Whoops!", "Better eyesight can#help sloppiness");
	
#define skill_type
	return "offensive";

#define update(_id)
	with(Player){
		with(instances_matching(instances_matching(instances_matching_ge(projectile, "id", _id), "creator", id), "direction", gunangle)){
			direction += random_range(-other.accuracy * 2, other.accuracy * 2)
		}
	}

#define late_step
	with(Player){
		if("sloppyprevreload" not in self){sloppyprevreload = 0;}
		if("sloppyderampspeed" not in self){sloppyderampspeed = 0;}
		if("sloppyaccuracyramp" not in self){sloppyaccuracyramp = 1;}
		if("sloppyreloadramp" not in self){sloppyreloadramp = 1;}
		
		accuracy /= sloppyaccuracyramp * skill_get(mod_current);
		reloadspeed /= sloppyreloadramp * skill_get(mod_current);
		
		if(reload > sloppyprevreload){
			sloppyaccuracyramp = min(sloppyaccuracyramp + (abs(reload * 0.005) + 0.025) * 2, (4 * 3) / (3 + skill_get(mut_eagle_eyes)));
			sloppyreloadramp = min(sloppyreloadramp + abs(reload * 0.005) + 0.025, 2);
			sloppyderampspeed = 0;
		}
		sloppyprevreload = reload;
		sloppyaccuracyramp = max(sloppyaccuracyramp - sloppyderampspeed * 2, 1);
		sloppyreloadramp = max(sloppyreloadramp - sloppyderampspeed, 1);
		sloppyderampspeed = min(sloppyderampspeed + 0.00025, 1);
	
		accuracy *= sloppyaccuracyramp * skill_get(mod_current);
		reloadspeed *= sloppyreloadramp * skill_get(mod_current);
		
		if(random(2) + 1 < sloppyreloadramp){
			instance_create(x,y,Smoke).direction = random(360);
			instance_create(x,y,Sweat).direction = random(360);
		}
	}