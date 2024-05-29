#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Energized Intestines.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Energized Intestines Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Energized Intestines";
	
#define skill_text
	return "@sSTUCK BOLTS @bZAP @wENEMIES";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;
	
#define skill_outcast
	return true;

#define skill_tip
	return "It's rave time";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	
#define late_step
with([Bolt, HeavyBolt, ToxicBolt, Seeker, Splinter, Disc, UltraBolt, CustomProjectile, BoltStick]){
	with(self){
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
			with instance_create(x+hspeed*4,y+vspeed*4,Lightning){
				alarm0 = 4;
				if("damage" not in other){
					ammo = 6;
				}else{
					ammo = min(max(other.damage/2, 6), 20);
				}
				if(other.object_index == BoltStick){
					image_angle = other.image_angle + 180;
				}else if other.speed > 0 {
					image_angle = other.direction + 180;
				} else {
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
}