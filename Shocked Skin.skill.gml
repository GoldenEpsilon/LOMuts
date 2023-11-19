#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Shocked Skin.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Shocked Skin Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call

#define skill_name
	return "Shocked Skin";
	
#define skill_text
	return "@wShells@s create @belectricity@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Shock absorption";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	
#define update(_id)
	with(Player){
		with(instances_matching_ne(instances_matching_gt(instances_matching([Bullet2, FlameShell, HeavySlug, UltraShell, Slug, HyperSlug, CustomProjectile], "creator", int64(self)), "id", _id), "ShockedSkin", true)){
			if((object_index != CustomProjectile || ("is_shell" in self && is_shell)) && fork()){
				var _x = x + hspeed + lengthdir_x(sprite_width/4, direction);
				var _y = y + vspeed + lengthdir_y(sprite_width/4, direction);
				var _t = team;
				var _damage = damage;
				while(instance_exists(self) && speed > 0){
					_x = x + hspeed + lengthdir_x(sprite_width/4, direction);
					_y = y + vspeed + lengthdir_y(sprite_width/4, direction);
					_t = team;
					wait(0);
				}
				wait(random(12));
				var newID = instance_create(0, 0, DramaCamera);
				with instance_create(_x,_y,Lightning){
					ammo = min(max(_damage/2, 1), 20);
					damage = ceil(sqrt(_damage));
					team = _t;
					with(self){
						event_perform(ev_alarm, 0);
					}
					var nearest = instance_nearest(x,y,enemy);
					if(nearest == noone){
						nearest = creator;
					}
					if(nearest != noone){
						direction = point_direction(x,y,nearest.x,nearest.y);
						image_angle = direction;
					}else{
						direction = random(360);
						image_angle = direction;
					}
				}
				with(instances_matching_ge(Lightning, "id", newID)){
					damage = ceil(sqrt(_damage));
				}
				exit;
			}
		}
	}