#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Iron Skin.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Iron Skin Icon.png", 1, 8, 8)
global.burst = sprite_add("../Sprites/SteelNervesBurst.png", 4, 16, 16)

#define skill_name
	return "Iron Skin";
	
#define skill_text
	return "When at full health#take @r1@s damage from the next attack";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "You've got skin of iron.";
	
#define skill_type
	return "outcast";
	
#define skill_take
	sound_play(sndMut);
	
#define skill_lose
with(Player){
	if(fork()){
		repeat(5){
			if(instance_exists(self) && "changedCanDie" in self && changedCanDie){
				candie = 1;
				changedCanDie = 0;
			}
			wait(0);
		}
	}
}
	
#define step
script_bind_begin_step(custom_step1, 0);
script_bind_end_step(custom_step2, 0);

#define custom_step1
with Player {
	OldHealth = my_health;
	if(my_health > 0 && candie == 1){
		candie = 0;
		changedCanDie = 1;
	}
}
instance_destroy();
#define custom_step2
with Player {
	if("changedCanDie" in self && "OldHealth" in self){
		if (my_health < OldHealth && OldHealth > maxhealth - skill_get(mod_current)){
			sound_play_pitchvol(sndHitMetal, 0.4, 3);
			with(instance_create(x,y,Effect)){
				sprite_index = global.burst;
				image_speed = 0.4;
				depth = -4;
				if(fork()){
					wait(4);
					while(image_index > current_time_scale){
						wait(0);
					}
					instance_destroy();
					exit;
				}
			}
			my_health = min(OldHealth - 1, max(maxhealth, my_health));
		}
		if(changedCanDie){
			candie = 1;
			changedCanDie = 0;
		}
	}
}
instance_destroy();