#define init
global.sprSkillIcon = sprite_add("../Sprites/Blights/Roulette Trigger.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Blights/Roulette Trigger Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getHooks"], "skill", mod_current);

#define skill_name
	return "Roulette Trigger";
	
#define skill_text
	return "Randomized Reload";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return false;

#define skill_blight
	return true;

#define skill_tip
	return "Off Rhythm";
	
#define skill_take
	sound_play(sndMut);

#define late_step
	with(Player){
		if("rouletteprevreload" not in self){rouletteprevreload = reload;}
		if(reload > rouletteprevreload){
			reload *= random_range(0.6, 1.4 + skill_get(mod_current) * 0.1);
		}
		rouletteprevreload = reload;
	}