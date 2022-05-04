#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Rabbit Ears";
	
#define skill_text
	return "Difficulty +20#(more @renemies@s, better @wweapons@s)";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Sharp Pointy Teeth";
	
#define skill_take
	sound_play(sndMut);
	GameCont.hard += 20;

#define skill_lose
	GameCont.hard -= 20;