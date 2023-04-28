#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Putrid Haze";
	
#define skill_text
	return "Being near toxic marks enemies.#Marked enemies take damage over time.";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "They who smelt it#@qDEALT IT";
	
#define skill_type
	return "outcast";
	
#define skill_take(_num)
	sound_play(sndMut);

#define step
	with(instances_matching_ne(enemy, "marked", true)){
		if(distance_to_object(ToxicGas) < 10){
			if("toxicmark" not in self){
				toxicmark = 0;
			}
			toxicmark += current_time_scale * skill_get(mod_current);
			if(toxicmark > 10){
				marked = true;
			}
		}
	}
	with(instances_matching(enemy, "marked", true)){
		if(call(scr.chance_ct, 1, 10)){
			projectile_hit_raw(self, skill_get(mod_current), 0);
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call