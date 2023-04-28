#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Fractured Fingers.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Fractured Fingers Icon.png", 1, 8, 8)
global.sprRocketExplo = sprite_add("Sprites/RocketExplo.png", 7, 12, 12)

#define skill_name
	return "Fractured Fingers";
	
#define skill_text
	return "Enemies killed by explosions#@wexplode@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Explosion babies";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMut)
	sound_play(sndMutant3Slct)
	wait(14)
	sound_play_pitch(sndMutant4Slct, 1.3)
	sound_play(sndExplosion)
	wait(2)
	sound_play(sndMutant3Hurt)
	
#define step

with(instances_matching_le(enemy, "my_health", 0)){
	if("FracturedFingers" not in self){
		FracturedFingers = 0;
		with(instances_matching_ne(Explosion, "FracturedFingers", skill_get(mod_current)+1)){
			if(object_index == PopoExplosion){continue;}
			if("FracturedFingers" not in self){
				FracturedFingers = 1;
			}else{
				if(FracturedFingers > skill_get(mod_current)){continue;}
				FracturedFingers++;
			}
			if(distance_to_object(other) < sqrt(sqr((sprite_width*image_xscale)/2)+sqr((sprite_height*image_yscale)/2)) && other.FracturedFingers <= skill_get(mod_current)){
				other.x += 10000;
				var _inst = instance_nearest(x,y,enemy);
				other.x -= 10000;
				other.FracturedFingers++;
				if("rocketcasings" in self && rocketcasings){
					with(instance_create(x + lengthdir_x(32,point_direction(x,y,_inst.x,_inst.y)),y + lengthdir_y(32,point_direction(x,y,_inst.x,_inst.y)),CustomProjectile)){
						FracturedFingers = other.FracturedFingers + 1;
						rocketcasings = true;
						duplicators = true;
						damage = skill_get("Rocket Casings");
						timer = 8;
						team = _t;
						image_speed = 0.4;
						sprite_index = global.sprRocketExplo;
						hitid = [sprite_index, "ROCKET AMMO"];
						mask_index = other.mask_index;
						image_blend = other.image_blend;
						on_wall = rocketWall;
						on_hit = rocketHit;
						on_step = rocketStep;
						with(instance_create(x,y,SmallExplosion)){
							FracturedFingers = other.FracturedFingers;
							sprite_index = mskNone;
							image_index = mskNone;
						}
						exit;
					}
				}else{
					with(instance_create(x + lengthdir_x(sprite_width,point_direction(x,y,_inst.x,_inst.y)),y + lengthdir_y(sprite_width,point_direction(x,y,_inst.x,_inst.y)),object_index)){
						if("name" in other){name = other.name}
						FracturedFingers = other.FracturedFingers + 1;
						damage = other.damage;
						sprite_index = other.sprite_index;
						image_xscale = other.image_xscale;
						image_yscale = other.image_yscale;
						mask_index = other.mask_index;
						image_blend = other.image_blend;
						team = other.team;
						WasteGland = irandom(1);
					}
				}
			}
		}
	}
}