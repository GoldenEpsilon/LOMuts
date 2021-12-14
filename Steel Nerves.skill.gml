#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Steel Nerves.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Steel Nerves Icon.png", 1, 8, 8)
global.burst = sprite_add("Sprites/SteelNervesBurst.png", 4, 16, 16)

#define skill_name
	return "Steel Nerves";
	
#define skill_text
	return "You can only take damage#up to 1/2 your max HP per hit";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "You've got nerves of steel.";
	
#define skill_take
	sound_play(sndMut);
	with(Player){
		nervesMax = maxhealth;
		steelNerves = (nervesMax+skill_get(mod_current)-1)/(1+skill_get(mod_current));
	}
	with(Revive){
		nervesMax = maxhealth;
		steelNerves = (nervesMax+skill_get(mod_current)-1)/(1+skill_get(mod_current));
	}
	sound_play_pitchvol(sndEnemyFire, 1, 2);
	wait(6);
	sound_play_pitchvol(sndEnemyFire, 1, 2);
	wait(4);
	sound_play_pitchvol(sndEnemyFire, 1, 2);
	wait(8);
	sound_play_pitchvol(sndMutant5Hurt, 1, 2);
	wait(2);
	sound_play_pitchvol(sndHitMetal, 0.3, 2);
	wait(8);
	sound_play(sndShotgun);
	
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
	if("steelNerves" not in self){
		nervesMax = maxhealth;
		steelNerves = (nervesMax+skill_get(mod_current)-1)/(1+skill_get(mod_current));
	}
	if(maxhealth != nervesMax){
		steelNerves += (maxhealth - nervesMax)/2;
		nervesMax = maxhealth;
	}
	OldHealth = my_health;
	if(my_health > 0 && candie == 1){
		candie = 0;
		changedCanDie = 1;
	}
}
instance_destroy();
#define custom_step2
with Player {
	if("steelNerves" in self && "changedCanDie" in self && "OldHealth" in self){
		if (my_health < OldHealth){
			if(my_health < floor(OldHealth-steelNerves) && OldHealth > floor(OldHealth-steelNerves)){
				sound_play_pitchvol(sndHitMetal, 0.3, 3);
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
			}
			my_health = min(max(my_health, floor(OldHealth-steelNerves)), maxhealth);
		}
		var nervesTemp = my_health - OldHealth;
		steelNerves += nervesTemp;
		if(fork()){
			wait(2);
			if(instance_exists(self)){
				steelNerves -= nervesTemp;
			}
			exit;
		}
		if(changedCanDie){
			candie = 1;
			changedCanDie = 0;
		}
	}
}
instance_destroy();