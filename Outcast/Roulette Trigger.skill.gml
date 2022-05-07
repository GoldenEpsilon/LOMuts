#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Roulette Trigger.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Roulette Trigger Icon.png", 1, 8, 8)
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
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Off Rhythm";
	
#define skill_take
	sound_play(sndMut);

#define late_step
	with(Player){
		if("rouletteprevreload" not in self){rouletteprevreload = reload;}
		if(reload > rouletteprevreload){
			reload *= random_range(0.4, 1.5);
		}
		rouletteprevreload = reload;
	}