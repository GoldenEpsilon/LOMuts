#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Energized Intestines.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Energized Intestines Icon.png", 1, 8, 8)
global.sprBurningLaser = sprite_add("Sprites/BurningLaser.png", 1, 2, 3)
global.bind_step = noone;

#define skill_name
	return "Energized Intestines";
	
#define skill_text
	return "@wBolts@s in @wwalls@s#zap enemies";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "It's rave time";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	
#define skill_lose
with(global.bind_step){
	instance_destroy();
}
	
#define cleanup
 // Unbind Script on Mod Unload:
with(global.bind_step){
	instance_destroy();
}
	
#define step
if(!instance_exists(global.bind_step)){
	global.bind_step = script_bind_end_step(late_step, 0);
}
#define late_step
with(instances_matching([Bolt, HeavyBolt, ToxicBolt, Seeker, Splinter, Disc, UltraBolt, CustomProjectile], "speed", 0)){
	if((object_index == CustomProjectile || object_index == CustomSlash) && ("ammo_type" not in self || ammo_type != 3)){
		continue;
	}
	if("eitimer" not in self){eitimer = 0;}
	if((eitimer * skill_get(mod_current)) % 12 == 0){
		with instance_create(x,y,Lightning){
			alarm0 = 4;
			ammo = max(other.damage/2, 6);
			var nearest = instance_nearest(x,y,enemy);
			if(nearest == noone){
				nearest = creator;
			}
			if(nearest != noone){
				image_angle = point_direction(x,y,nearest.x,nearest.y);
			}else{
				image_angle = other.image_angle;
			}
			team = other.team;
		}
	}
	eitimer++;
}