#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call

#define skill_name
	return "Feed Forward Network";
	
#define skill_text
	return "Energy @wMelee@s weapons#@wecho@s";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Fast Feed";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return true;
	
#define update(_id)
	with(Player){
		with(instances_matching_ne(instances_matching_gt(instances_matching([LightningSlash, EnergySlash, EnergyShank, EnergyHammerSlash], "creator", int64(self)), "id", _id), "FeedForward", true)){
			if(fork()){
				var _x = x + hspeed + lengthdir_x(sprite_width/4, direction);
				var _y = y + vspeed + lengthdir_y(sprite_width/4, direction);
				var _t = team;
				var _oi = object_index;
				var _damage = damage;
				var _xscale = image_xscale;
				var _yscale = image_yscale;
				var _direction = direction;
				var _image_angle = image_angle;
				while(instance_exists(self) && speed > 0){
					_x = x + hspeed + lengthdir_x(sprite_width/4, direction);
					_y = y + vspeed + lengthdir_y(sprite_width/4, direction);
					_direction = direction;
					_image_angle = image_angle;
					_t = team;
					wait(0);
				}
				repeat(irandom(2) + 3){
					with(instance_create(_x,_y,_oi)){
						FeedForward = true;
						direction = _direction;
						image_angle = _image_angle;
						speed = 3;
						team = _t;
						damage = _damage;
						image_xscale = _xscale;
						image_yscale = _yscale;
					}
				}
				exit;
			}
		}
	}