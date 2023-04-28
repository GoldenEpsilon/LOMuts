#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Greed.png", 1, 12, 16);
global.sprSkillHUD = sprite_add("Sprites/Icons/Greed Icon.png", 1, 8, 8);
global.greedsTaken = 0;

#define greed_calc
	return max(60 - global.greedsTaken * 5, 0);

#define skill_name
	return "Greed";
	
#define skill_text
	return "Gain "+ string(greed_calc()) +" rads#take 1 damage#(this does not take a mutation)";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_sacrifice return false; //metamorphosis compat thing

#define skill_avail
	return (!instance_is(self, CustomObject) && !instance_is(self, CustomProp)) || instance_exists(Loadout);

#define skill_tip
	return "Greed is good!";
	
#define skill_type
	return "reusable";

#define skill_temp
	return 1;

#define skill_reusable
	return 1;
	
#define game_start
	global.greedsTaken = 0;
	
#define skill_take(_num)
	sound_play(sndMut);
	with(Player){
		my_health--;
		lsthealth--;
		lasthit = [global.sprSkillHUD, "GREED"];
	}
	GameCont.rad += greed_calc();
	global.greedsTaken++;
	with(instances_matching(SkillIcon, "skill", mod_current)){
		text = skill_text();
	}