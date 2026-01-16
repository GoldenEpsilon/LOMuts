#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Deep Residual Network";
	
#define skill_text
	return `@(color:${c_lime})Plasmites@s duplicate on @wkill@s`;

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "The @qSwarm";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return "defpack tools";
	
#define step
script_bind_step(custom_step, 0);
#define custom_step
with(instances_matching_ne(WepPickup, "neural", true)){
	neural = true;
	var name = weapon_get_name(wep);
	if(roll == 1 && string_count("Plasmite", name) == 0) {
		wep = weapon_random(weapon_get_area(wep), weapon_get_area(wep));
	}
}
with(Player){
	with(instances_matching(instances_matching(CustomProjectile,"recurrent",null),"team",team)){
		recurrent = 1;
		if(recurrent < 4 * skill_get(mod_current) && "name" in self && is_string(name) && string_count("plasmite", string_lower(name)) > 0){
			if(fork()){
				var _x = x + hspeed + lengthdir_x(sprite_width/4, direction);
				var _y = y + vspeed + lengthdir_y(sprite_width/4, direction);
				var _t = team;
				var _c = creator;
				var _r = recurrent;
				while(instance_exists(self)){
					_x = x + hspeed + lengthdir_x(sprite_width/4, direction);
					_y = y + vspeed + lengthdir_y(sprite_width/4, direction);
					_t = team;
					wait(0);
				}
				with(instances_matching_le(enemy, "my_health", 0)){
					if(abs(x - _x) + abs(y - _y) < sprite_width + sprite_height){
						repeat(skill_get(mod_current) * 3){
							with(mod_script_call("mod", "defpack tools", "create_plasmite", _x,_y)){
								recurrent = _r + 1;
								duplicators = true;
								team = _t;
								creator = _c;
								direction = random(360);
								maxspeed *= 1.1;
								speed = maxspeed;
							}
						}
						break;
					}
				}
				exit;
			}
		}
	}
}
instance_destroy();

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