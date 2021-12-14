#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Unstable DNA.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Unstable DNA Icon.png", 1, 8, 8)

#define skill_name
	return "Unstable DNA";
	
#define skill_text
	return "@wReset@s to level one (keeping mutations)#lose half your @rmax HP@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_sacrifice return false; //metamorphosis compat thing

#define skill_avail
	return GameCont.level >= 5 && (!instance_is(self, CustomObject) && !instance_is(self, CustomProp)) || instance_exists(Loadout);

#define skill_tip
	return "I don't feel so good...";

#define skill_temp
	return 1;
	
#define skill_take
	sound_play(sndMutOpenMind);
	GameCont.level = 1;
	GameCont.rad = 0;
	with Player {
		maxhealth = ceil(maxhealth / 2);
		if(my_health > maxhealth){my_health = maxhealth;lsthealth = maxhealth;}
	}

#define skill_lose
	with Player {
		maxhealth = floor(maxhealth * 2);
	}