#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Shattered Skull.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Shattered Skull Icon.png", 1, 8, 8)

#define skill_name
	return "Shattered Skull";
	
#define skill_text
	return "@wShells@s split into #@wmore shells@s when they are fired";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "360 No Scope";
	
#define skill_bodypart return 1
	
#define skill_take
	sound_play(sndMut)
	sound_play_pitchvol(sndWallBreakRock, 1.4, 1)
	wait(4);
	sound_play_pitchvol(sndWallBreakBrick, 0.4, 1)
	
#define step
script_bind_step(custom_step, 0);
#define custom_step
with(instances_matching_ne(instances_matching_ne([Bullet2, FlameShell, HeavySlug, UltraShell, Slug], "ShatteredSkull", 1), "pg", 1)){
	ShatteredSkull = 1;
	if(damage >= 1){
		repeat(max(irandom(sqrt(damage)), 0) * skill_get(mod_current)){
			var split = instance_clone();
			split.team = team;
			split.direction = direction + random_range(-10, 10);
			split.image_angle = direction;
			split.ShatteredSkull = 1;
			split.damage = round(damage/2);
			split.image_xscale = image_xscale/2;
			split.image_yscale = image_yscale/2;
		}
	}
}
with(instances_matching_ne(CustomProjectile, "ShatteredSkull", 1)){
	ShatteredSkull = 1;
	if("is_slug" in self && is_slug && damage >= 1){
		repeat(max(irandom(sqrt(damage)), 0) * skill_get(mod_current)){
			var split = instance_clone();
			split.team = team;
			split.direction = direction + random_range(-10, 10);
			split.ShatteredSkull = 1;
			split.damage = round(damage/2);
			split.image_xscale = image_xscale/2;
			split.image_yscale = image_yscale/2;
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
	