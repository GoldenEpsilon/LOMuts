#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Garment Regenerator.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Garment Regenerator Icon.png", 1, 8, 8)

#define skill_name
	return "Garment Regenerator";
	
#define skill_text
	return "When you take damage,#@rheal@s half of it back after a second.";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Warm";
	
#define skill_type
	return "defensive";
	
#define skill_take
	sound_play(sndMut);
	sound_play_pitch(sndMutant10Hurt, 0.95);
	wait(15);
	sound_play_pitch(sndRobotEat, 0.4);
	wait(10);
	sound_play_pitch(sndRobotEat, 0.6);
	wait(20);
	sound_play(sndMutant10Slct);
	
#define step

with Player {
	if (fork()) {
		var OldHealth = my_health;
		wait 0
		if(instance_exists(self) && my_health < OldHealth && my_health != lsthealth){
			var healHealth = floor((OldHealth - max(my_health,0))/2)
			wait(60 / skill_get(mod_current));
			if(instance_exists(self)){
				my_health += healHealth;
				my_health = min(my_health, maxhealth);
			}
		}
		exit
	}
}