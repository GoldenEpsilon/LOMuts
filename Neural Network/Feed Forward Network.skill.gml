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
	return "@wENERGY MELEE @sWEAPONS @wECHO";

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
with(instances_matching_ne(WepPickup, "neural", true)){
	neural = true;
	if(roll == 1 && (weapon_get_type(wep) != 5 || !weapon_is_melee(wep))) {
		wep = weapon_random(weapon_get_area(wep), weapon_get_area(wep));
	}
}
	with(Player){
		with(instances_matching_ne(instances_matching_gt(instances_matching([LightningSlash, EnergySlash, EnergyShank, EnergyHammerSlash, CustomSlash], "creator", id), "id", _id), "FeedForward", true)){
			FeedForward = true;
			if(object_index == CustomSlash && !("is_melee" in self && is_melee && "ammo_type" in self && ammo_type == 5)){
				continue;
			}
			if(fork()){
				if("feed_forward" not in self){
					feed_forward = 0;
				}
				var _x = x + hspeed + lengthdir_x(sprite_width/4, direction);
				var _y = y + vspeed + lengthdir_y(sprite_width/4, direction);
				var _t = team;
				var _creator = creator;
				var _oi = object_index;
				var _damage = damage;
				var _xscale = image_xscale;
				var _yscale = image_yscale;
				var _direction = direction;
				var _image_angle = image_angle;
				var _f = feed_forward;
				while(instance_exists(self) && speed > 0){
					_x = x + hspeed + lengthdir_x(sprite_width/4, direction);
					_y = y + vspeed + lengthdir_y(sprite_width/4, direction);
					_direction = direction;
					_image_angle = image_angle;
					_t = team;
					wait(0);
				}
				with(instance_create(_x,_y,_oi)){
					feed_forward = _f + 1;
					image_alpha = (skill_get(mod_current) + 1 - feed_forward) / (skill_get(mod_current) + 1)
					if(feed_forward >= skill_get(mod_current)){
						FeedForward = true;
					}
					direction = _direction;
					image_angle = _image_angle;
					speed = 3;
					team = _t;
					creator = _creator;
					damage = _damage;
					image_xscale = _xscale;
					image_yscale = _yscale;
				}
				exit;
			}
		}
	}

#define weapon_random(_hardMin, _hardMax)
	/*
		Returns a random weapon that spawns within the given difficulties
		
		Ex:
			wep = weapon_random(0, GameCont.hard);
	*/
	
	var	_list = ds_list_create(),
		_size = weapon_get_list(_list, _hardMin, _hardMax),
		_pick = wep_none;
		
	if(_size > 0){
		_pick = ds_list_find_value(_list, irandom(_size - 1));
		ds_list_destroy(_list);
	}
	
	return _pick;