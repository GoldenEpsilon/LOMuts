#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Survivor's Instinct";
	
#define skill_text
	return "massive @wspeed boost@s#at 1 health";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Run, run, as fast as you can#you can't catch me, I'm the @qmutation man!";
	
#define skill_take
	sound_play(sndMut);
	
	
#define skill_lose
with(Player){
	if(laststand > 0){
		laststand = 0;
		maxspeed -= 1 + skill_get(mod_current);
	}
}
#define step
with(Player){
	if("laststand" not in self){
		laststand = 0;
	}
	if(my_health <= 1 && laststand <= 0){
		laststand = 1;
		maxspeed += 1 + skill_get(mod_current);
	}
	if(my_health > 1 && laststand > 0){
		laststand = 0;
		maxspeed -= 1 + skill_get(mod_current);
	}
}