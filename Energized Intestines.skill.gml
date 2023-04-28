#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Energized Intestines.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Energized Intestines Icon.png", 1, 8, 8)
global.sprBurningLaser = sprite_add("Sprites/BurningLaser.png", 1, 2, 3)
global.bind_step = noone;

#define skill_name
	return "Energized Intestines";
	
#define skill_text
	return "Stuck @wBolts@s#@bzap@s enemies";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "It's rave time";
	
#define skill_type
	return "offensive";
	
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
with(instances_matching([Bolt, HeavyBolt, ToxicBolt, Seeker, Splinter, Disc, UltraBolt, CustomProjectile, BoltStick], "speed", 0)){
	if((object_index == CustomProjectile || object_index == CustomSlash) && ("ammo_type" not in self || ammo_type != 3)){
		continue;
	}
	if(object_index == BoltStick){
		if(sprite_index != sprBolt && sprite_index != sprSeeker && sprite_index != sprUltraBolt && sprite_index != sprBoltGold && sprite_index != sprToxicBolt && sprite_index != sprHeavyBolt){
			continue;
		}else{
			if("team" not in self){
				team = 0;
				with(Player){
					if(!instance_exists(other.target) || "team" not in other.target || team != other.target.team){
						other.team = team;
						break;
					}
				}
			}
		}
	}
	if("eitimer" not in self){eitimer = 0;}
	if((eitimer * skill_get(mod_current)) % 12 == 0){
		if(object_index == BoltStick){
			if("eishocks" not in self){
				eishocks = 4;
			}
			eishocks--;
			if(eishocks <= 0){
				continue;
			}
		}
		with instance_create(x,y,Lightning){
			alarm0 = 4;
			if("damage" not in other){
				ammo = 6;
			}else{
				ammo = min(max(other.damage/2, 6), 20);
			}
			if(other.object_index == BoltStick){
				image_angle = other.image_angle + 180;
			}else{
				var nearest = instance_nearest(x,y,enemy);
				if(nearest == noone){
					nearest = creator;
				}
				
				if(nearest != noone){
					image_angle = point_direction(x,y,nearest.x,nearest.y);
				}else{
					image_angle = other.image_angle;
				}
			}
			team = other.team;
		}
	}
	eitimer++;
}