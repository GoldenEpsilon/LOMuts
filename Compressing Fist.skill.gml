#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Compressing Fist.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Compressing Fist Icon.png", 1, 8, 8)

#define skill_name
	return "Compressing Fist";
	
#define skill_text
	return "1.5x @wammo usage@s,#1.5x @wdamage@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Fused ammo is surprisingly effective";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMut);
	sound_play_pitchvol(sndMutant7Slct, 1.1, 1.2);
	wait(10);
	sound_play(sndWallBreakBrick);
	
#define step
with(Player){
	compOldAmmo = [];
	for(var i = 0; i < array_length(ammo); i++){
		array_push(compOldAmmo, real(ammo[i]));
	}
	compOldReload = reload;
	compOldBReload = breload;
	compOldWep = wep;
}
script_bind_step(custom_step, -6);
#define custom_step
with(Player){
	if("compAmmoRemainder" not in self){
		compAmmoRemainder = [];
		for(var i = 0; i < array_length(ammo); i++){
			array_push(compAmmoRemainder, 0);
		}
	}
	if("compOldAmmo" in self){
		for(var i = 0; i < array_length(ammo); i++){
			if(ammo[i] < compOldAmmo[i]){
				var val = ((ammo[i] - compOldAmmo[i])/2) * skill_get(mod_current) + compAmmoRemainder[i];
				ammo[i] += floor(val);
				compAmmoRemainder[i] = val - floor(val)
				if(ammo[i] < 0){ammo[i] = 0;}
			}
		}
		if(reload > compOldReload && wep == compOldWep && (is_string(wep) || is_object(wep) || wep > 0) && weapon_get_cost(wep) == 0){
			reload *= 1 + 0.5 * skill_get(mod_current);
		}
		if(breload > compOldBReload && wep == compOldWep && (is_string(bwep) || is_object(wep) || bwep > 0) && weapon_get_cost(bwep) == 0){
			breload *= 1 + 0.5 * skill_get(mod_current);
		}
	}
}
with(instances_matching(instances_matching_ne(instances_matching_ne(projectile, "ammo_type", -1),"comp_fist",true),"team",2)){
	if(!(skill_get("powderedgums") && object_index == HyperSlug)){
		damage = floor(damage * 1.5 * skill_get(mod_current));
			//if creator != noone && instance_is(creator, Player) && weapon_get_type(creator.wep) != 0 spazFistEffects();
		image_yscale *= 1.5;
	}
	comp_fist = true;
}
instance_destroy();

#define spazFistEffects

switch(sprite_index){
	case sprGrenade: case sprHeavyNade: case sprFlare: case sprRocket: case sprNuke: case sprFlameBall:
		var sprite = sprFireBall; break;
		
	case sprLaser: 
		var sprite = sprPlasmaBall; break;

	case sprLightning: 
		var sprite = sprLightningHit; break;
		
	case sprBolt: case sprHeavyBolt:
		var sprite = sprSplinter; break;

	default: 
		var sprite = sprite_index; break;
}

//Side Spray

repeat(floor(min(5,damage / 4))){
	with(instance_create(x + lengthdir_x(3,creator.gunangle), y + lengthdir_y(3,creator.gunangle), PlasmaTrail)){
		direction = other.creator.gunangle + 60 * choose(-1,1) + random_range(-15,15)
		speed = 5 + random_range(0.1,4);
		friction = random_range(0.2, 0.7);
		sprite_index = sprite;
		image_speed = 0;
		image_index = 0;
		var rand_size = random(0.2)
		image_xscale = 0.65 + rand_size;
		image_yscale = 0.65 + rand_size;
		image_angle = direction;
		depth = other.depth + 1
		if(fork()){
			while(image_xscale > 0){
				image_xscale -= 0.05;
				image_yscale -= 0.05;
				wait(1);
				if(!instance_exists(self)){
					exit;
				}
			}
			instance_destroy();
			exit;
		}
	}
}

//front spray
repeat(floor(min(8,speed / 5))){
	with(instance_create(x + lengthdir_x(1,creator.gunangle), y + lengthdir_y(1,creator.gunangle), PlasmaTrail)){
		direction = other.creator.gunangle + random_range(-8,8)
		speed = 7 + random_range(0.1,7);
		friction = random_range(0.2, 0.7);
		sprite_index = sprite;
		image_speed = 0;
		image_index = 0;
		image_xscale = 0.65;
		image_yscale = 0.65;
		image_angle = direction;
		depth = other.depth + 1
		if(fork()){
			while(image_xscale > 0){
				image_xscale -= 0.05;
				image_yscale -= 0.05;
				wait(1);
				if(!instance_exists(self)){
					exit;
				}
			}
			instance_destroy();
			exit;
		}
	}
}

