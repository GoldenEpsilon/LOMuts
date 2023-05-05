#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call

#define skill_name
	return "Aerodynamic Ankles";
	
#define skill_text
	return "@wShells@s pull#enemies along";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;
	
#define skill_outcast
	return true;

#define skill_tip
	return "Be with the wind";
	
#define skill_type
	return "outcast";
	
#define skill_bodypart return 2
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	
#define late_step
with(Player){
	with(instances_matching_ne(instances_matching([Bullet2, FlameShell, HeavySlug, UltraShell, Slug], "team", team), "AeroAnkles", true)){
		with(call(scr.instances_meeting, x+hspeed_raw, y+vspeed_raw, instances_matching_ne(hitme, "team", team))){
			other.AeroAnkles = true;
			with(call(scr.superforce_push, self, (other.force) * skill_get(mod_current) + 2, other.direction, 1, true, true, false, script_ref_create(merge))){
				hook_wallhit = script_ref_create(wallHit);
			}
		}
	}
	with(instances_matching_ne(instances_matching(instances_matching(CustomProjectile, "is_shell", true), "team", team), "AeroAnkles", true)){
		with(call(scr.instances_meeting, x+hspeed_raw, y+vspeed_raw, instances_matching_ne(hitme, "team", team))){
			other.AeroAnkles = true;
			with(call(scr.superforce_push, self, (other.force) * skill_get(mod_current) + 2, other.direction, 1, true, true, false, script_ref_create(merge))){
				hook_wallhit = script_ref_create(wallHit);
			}
		}
	}
}

#define wallHit
return true;

#define merge(curr, prev)
	curr.superforce += prev.superforce;