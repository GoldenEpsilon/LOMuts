#define init
global.sprSkillIcon = sprite_add("../Sprites/Blights/Damocles Tendon.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Blights/Damocles Tendon Icon.png", 1, 8, 8)

#define skill_name
	return "Damocles Tendon";
	
#define skill_text
	return "When you take damage,#there is a @w5%@s chance to #@rlose max health@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Watch the ankle";

#define skill_avail
	return false;

#define skill_blight
	return true;
	
#define skill_take
	sound_play(sndMut);
	
#define step

with Player {
	if (fork()) {
		var OldHealth = my_health;
		wait 0
		if(instance_exists(self) && my_health < OldHealth && random(100) < 5*skill_get(mod_current)){
			maxhealth -= 2;
			chickendeaths += 2;
			repeat(5){
				with(instance_create(x,y,BloodStreak)){
					direction = random(360);
					speed = 2;
				}
			}
		}
		exit
	}
}