#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Double Vision.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Double Vision Icon.png", 1, 8, 8)
global.modifier = 6;
global.acc = 20;

#define skill_name
	return "Double Vision";
	
#define skill_text
	return "Chance to @wduplicate@s shots";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Duplication is imprecise";
	
#define skill_take
	sound_play(sndMutEagleEyes);
	
#define step
script_bind_step(custom_step, 1);

#define custom_step
with(Player){
	with(instances_matching(instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching_ne(projectile,"DoubleVision",true), "name", "Bone"), "pg", 1), "object_index", ThrownWep), "object_index", HorrorBullet),"team",team)){
		DoubleVision = true;
		if(random(global.modifier / skill_get(mod_current)) < 1 && !("name" in self && is_string(name) && (string_count("vector", string_lower(name)) > 0))){
			with(instance_clone()){
				team = other.team;
				//damage = other.damage / global.modifier;
				if(object_index == BloodSlash){
					creator = -4;
				}
				if(object_index != Laser){
					var r = random_range(-global.acc,global.acc);
					direction += r;
					image_angle += r;
				}else{
					x -= lengthdir_x(image_xscale*2,direction);
					y -= lengthdir_y(image_xscale*2,direction);
					with instance_create(x,y,Laser){
						alarm0 = 1;
						var r = random_range(-global.acc,global.acc);
						direction = other.direction + r;
						image_angle = other.image_angle + r;
						hitid = [sprite_index, "LASER"];
						team = other.team;
						creator = other;
					}
					instance_destroy();
				}
			}
		}
	}
}
instance_destroy();

#define instance_clone()
	/*
		Duplicates an instance like 'instance_copy(false)' and clones all of their data structures
	*/
	
	with(instance_copy(false)){
		with(variable_instance_get_names(self)){
			var	_value = variable_instance_get(other, self),
				_clone = data_clone(_value);
				
			if(_value != _clone){
				variable_instance_set(other, self, _clone);
			}
		}
		
		return id;
	}

#define data_clone(_value)
	/*
		Returns an exact copy of the given value
	*/
	
	if(is_array(_value)){
		return array_clone(_value);
	}
	if(is_object(_value)){
		return lq_clone(_value);
	}
	if(ds_list_valid(_value)){
		return ds_list_clone(_value);
	}
	if(ds_map_valid(_value)){
		return ds_map_clone(_value);
	}
	if(ds_grid_valid(_value)){
		return ds_grid_clone(_value);
	}
	if(surface_exists(_value)){
		return surface_clone(_value);
	}
	
	return _value;

#define ds_list_clone(_list)
	/*
		Returns an exact copy of the given ds_list
	*/
	
	var _new = ds_list_create();
	
	ds_list_add_array(_new, ds_list_to_array(_list));
	
	return _new;
	
#define ds_map_clone(_map)
	/*
		Returns an exact copy of the given ds_map
	*/
	
	var _new = ds_map_create();
	
	with(ds_map_keys(_map)){
		_new[? self] = _map[? self];
	}
	
	return _new;
	
#define ds_grid_clone(_grid)
	/*
		Returns an exact copy of the given ds_grid
	*/
	
	var	_w = ds_grid_width(_grid),
		_h = ds_grid_height(_grid),
		_new = ds_grid_create(_w, _h);
		
	for(var _x = 0; _x < _w; _x++){
		for(var _y = 0; _y < _h; _y++){
			_new[# _x, _y] = _grid[# _x, _y];
		}
	}
	
	return _new;
	
#define surface_clone(_surf)
	/*
		Returns an exact copy of the given surface
	*/
	
	var _new = surface_create(surface_get_width(_surf), surface_get_height(_surf));
	
	surface_set_target(_new);
	draw_clear_alpha(0, 0);
	draw_surface(_surf, 0, 0);
	surface_reset_target();
	
	return _new;
	