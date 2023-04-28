#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Shivering Spine";
	
#define skill_text
	return "@wprojectiles@s move faster#and are more @wslippery@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "It's beginning to look a lot like#@qTHE DEMISE OF YOUR ENEMIES";
	
#define skill_type
	return "outcast";
	
#define skill_take
	sound_play(sndMut);

#define step
	
#define update(_id)
	var teams = [];
	with(Player){
		if(array_find_index(teams, team) == -1){
			array_push(teams, team);
		}
	}
	with(teams){
		if(instance_exists(self)){
			with(instances_matching(instances_matching_gt(instances_matching_gt(instances_matching_ne(instances_matching_gt(projectile, "id", _id), "ammo_type", -1), "speed", 0), "damage", 0), "team", self)){
				speed *= 1 + skill_get(mod_current) * 0.25;
				friction *= 2 / (2 + skill_get(mod_current));
			}
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call