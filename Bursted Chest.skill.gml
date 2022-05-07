#define init
global.sprSkillIcon = sprite_add("Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Bursted Chest";
	
#define skill_text
	return "When you take damage,#create an @wally@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Warm";
	
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
		var tempTeam = team;
		wait 0
		if(instance_exists(self) && my_health < OldHealth && array_length(instances_matching(instances_matching(Ally, "name", "Bursted"), "creator", self)) < skill_get(mod_current) * 4){
			with(instance_create(x,y,Ally)){
				creator = other;
				team = tempTeam;
				name = "Bursted";
			}
		}
		exit
	}
}