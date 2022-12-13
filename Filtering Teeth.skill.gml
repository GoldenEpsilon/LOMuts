#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Filtering Teeth.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Filtering Teeth Icon.png", 1, 8, 8)

#define skill_name
	return "Filtering Teeth";
	
#define skill_text
	return "Pickups and Rads#last longer";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Five second rule";
	
#define skill_take
	sound_play(sndMut); sound_mutation_play();
	
#define skill_bodypart return 1

#define step
with(Pickup){
	if("filtered" not in self){
		filtered = true;
		alarm0 *= 1 + skill_get(mod_current) * 4;
	}
}

#define sound_mutation_play()
	sound_play(sndMut);
	with instance_create(0, 0, CustomObject){
		lifetime = 0;
		stage = 0;
		pitch = 1;
		on_step = sound_step
	}

#define sound_step
	lifetime += current_time_scale;
	if lifetime >= 5 && stage = 0{
		stage++;
		sound_play(sndMutant8LowH)
		sound_play_pitchvol(sndMutant8LowA, 1.4, .7)
	}
	if lifetime > 8 && stage = 1{
		stage++;
		sound_play_pitchvol(sndRobotEat, 1.3, .9)
	}
	if lifetime > 10 && stage = 2{
		stage++;
		sound_play_pitchvol(sndHPPickupBig, 1, .7)
	}
	if lifetime > 20 && stage = 3{
		stage++;
		sound_play_pitchvol(sndRobotEat, 1, 1)
		sound_play_pitchvol(sndAmmoPickup, 1.1, .9)
	}

	if lifetime > 35 && stage = 4{
		stage++;
		sound_play_pitchvol(sndRegurgitate, 1.2, 2)
	}
	if lifetime > 55 && stage = 5{
		stage++;
        sound_play_pitchvol(sndHitPlant, .85, .9)
		sound_play_pitchvol(sndJungleAssassinHurt, 1.1, .9)
		sound_play_pitchvol(sndHitWall, 1.2, .7)
	}