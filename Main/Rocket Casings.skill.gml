#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Rocket Casings.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Rocket Casings Icon.png", 1, 8, 8)
global.sprRocketExplo = sprite_add("../Sprites/RocketExplo.png", 7, 12, 12)
global.sprRocketExploGreen = sprite_add("../Sprites/RocketExploGreen.png", 7, 12, 12)

#define skill_name
	return "Rocket Casings";
	
#define skill_text
	return "@wBullets@s go @wfaster@s and @wexplode@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "WHOOSH";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMut); sound_mutation_play();
	
#define step
script_bind_step(custom_step, 0);
#define custom_step
with(Player){
	with(instances_matching(instances_matching_ne([Bullet1,UltraBullet,HeavyBullet,BouncerBullet,CustomProjectile],"rocketcasings",true),"team",team)){
		if(object_index == Bullet1 && skill_get("excitedneurons")){continue;}
		if((object_index == CustomProjectile || object_index == CustomSlash)){
			if(!((("ammo_type" in self && ammo_type == 1) || ("is_bullet" in self && is_bullet == true)))){
				rocketcasings = true;
			}else{
				speed = speed + 3;
				force = force * 2;
				rocketcasings = true;
				rocket_on_destroy = on_destroy;
				on_destroy = customRocketCasings;
			}
			continue;
		}
		speed = speed + 3;
		force = force * 2;
		rocketcasings = true;
		if(fork()){
			var _x = x + hspeed;
			var _dirx = lengthdir_x(sprite_width/4, direction);
			var _y = y + vspeed;
			var _diry = lengthdir_y(sprite_width/4, direction);
			var _t = team;
			var _d = damage;
			while(instance_exists(self)){
				_x = x + hspeed;
				_y = y + vspeed;
				_dirx = lengthdir_x(sprite_width/4, direction);
				_diry = lengthdir_y(sprite_width/4, direction);
				_t = team;
				wait(0);
			}
			with(instance_create(_x + _dirx,_y + _diry,CustomProjectile)){
				hitframe = -1;
				rocketcasings = true;
				duplicators = true;
				pyroflammable = true;
				damage = 1 * skill_get(mod_current);
				force = 3 * skill_get(mod_current);
				timer = 8;
				team = _t;
				image_speed = 0.4;
				sprite_index = global.sprRocketExplo;
				if(_d > 20){
					force *= 2;
					damage = 4 * skill_get(mod_current);
					sprite_index = global.sprRocketExploGreen;
				}else if(_d > 5){
					force *= 1.5;
					damage = 2 * skill_get(mod_current);
				}
				hitid = [sprite_index, "ROCKET AMMO"];
				mask_index = mskSmallExplosion;
				on_wall = rocketWall;
				on_hit = rocketHit;
				on_step = rocketStep;
				with(instance_create(_x - _dirx * 2,_y - _diry * 2,SmallExplosion)){
					image_alpha = 0;
					image_speed = 0.4;
					sprite_index = global.sprRocketExplo;
					mask_index = mskNone;
				}
			}
			exit;
		}
	}
}
instance_destroy();

#define customRocketCasings
	with(instance_create(x,y,SmallExplosion)){
		image_alpha = 0;
		image_speed = 0.4;
		sprite_index = global.sprRocketExplo;
		mask_index = mskNone;
	}
	script_ref_call(on_destroy);

#define rocketWall
#define rocketHit
if(hitframe == -1 || hitframe == current_frame){
	projectile_hit(other, damage, force, direction);
	hitframe = current_frame;
}
#define rocketStep
timer--;
if(timer < 0 && instance_exists(self)){
	instance_destroy();
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
	if lifetime > 5 && stage = 0{
		stage++;
		sound_play(sndEmpty)
		sound_play_pitchvol(sndNadeReload, 1, 2)
	}
	if lifetime > 10 && stage = 1{
		stage++;
		sound_play(sndEmpty)
		sound_play_pitchvol(sndNadeReload, 1.1, 2)
	}
	if lifetime > 16 && stage = 2{
		stage++;
		sound_play(sndEmpty)
		sound_play_pitchvol(sndNadeReload, 1.2, 2)
	}
	if lifetime > 19 && stage = 3{
		stage++;
		sound_play_pitchvol(sndTripleMachinegun, 1, 1)
	}
    if lifetime > 22 && stage = 4{
		stage++;
		sound_play_pitchvol(sndTripleMachinegun, 1.2, 1)
}		
    if lifetime > 27 && stage = 5{
		stage++;
		sound_play_pitchvol(sndTripleMachinegun, 1.2, 1)
}
   if lifetime > 29 && stage = 6{
		stage++;
		sound_play_pitchvol(sndExplosion, 1.2, .7)
		sound_play(sndFlyDead)
		sound_play_pitchvol(sndExplosion, 1.1, .8)
}
   if lifetime > 33 && stage = 7{
		stage++;
		sound_play(sndBanditDie)
		sound_play_pitchvol(sndExplosionXL, 1.1, 0.9)
}