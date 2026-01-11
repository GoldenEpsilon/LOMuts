#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Laser Focus.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Laser Focus Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Laser Focus";
	
#define skill_text
	return "Some enemies are @rmarked@s#@rMarked@s enemies take @wextra damage@s#The Mark @wshifts@s when they die";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_tip
	return "Can't Blink";
	
#define skill_type
	return "offensive";
	
#define skill_take(_num)
	sound_play(sndMut);

#define level_start
	repeat(skill_get(mod_current) * max(1, instance_number(enemy)/50)){
		with(call(scr.instance_random, instances_matching_ne(enemy, "marked", true))){
			marked = true;
		}
	}

#define step
	with(instances_matching(enemy, "marked", true)){
		if("my_health" in self){
			if("prevHealth" not in self){
				prevHealth = my_health;
			}
			if(my_health < prevHealth){
				my_health -= (prevHealth - my_health) * skill_get(mod_current) * 0.5;
				// my_health -= skill_get(mod_current)
			}
			prevHealth = my_health;
			if(my_health <= 0){
				with(instance_nearest_from(x, y, instances_matching_ne(enemy, "marked", true))){
					marked = true;
				}
			}
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call