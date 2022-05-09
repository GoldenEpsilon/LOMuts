#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Explosive Gaze";
	
#define skill_text
	return "Five enemies are @rmarked@s per level#@rMarked@s enemies @wexplode@s on death";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Scared to Blink";
	
#define skill_take(_num)
	sound_play(sndMut);

#define level_start
	repeat(5 * skill_get(mod_current)){
		with(call(scr.instance_random, instances_matching_ne(enemy, "marked", true))){
			marked = true;
		}
	}

#define step
	with(instances_matching(enemy, "marked", true)){
		if("my_health" in self && my_health <= 0){
			sound_play(sndExplosion);
			instance_create(x,y,Explosion);
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call