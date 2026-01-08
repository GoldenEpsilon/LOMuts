#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Shattered Skull.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Shattered Skull Icon.png", 1, 8, 8)

#define skill_name
	return "Shattered Skull";
	
#define skill_text
	return "@wSHELLS @sMAKE#@wLINGERING SHOTS";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "360 No Scope";
	
#define skill_type
	return "offensive";
	
#define skill_bodypart return 1
	
#define skill_take
	sound_play(sndMut)
	sound_play_pitchvol(sndWallBreakRock, 1.4, 1)
	wait(4);
	sound_play_pitchvol(sndWallBreakBrick, 0.4, 1)
	
#define step
script_bind_step(custom_step, 0);
if instance_exists(projectile){
	var inst = instances_matching([Bullet2,FlameShell,UltraShell,FlakBullet,SuperFlakBullet,Slug,HeavySlug],"Cellulite", 1); //vanilla
	var cust = instances_matching(CustomProjectile,"Cellulite", 1); //custom shells
	
	if array_length(inst) with inst {
		stall_shell_step()
	}
	
	if array_length(cust) with cust {
		stall_shell_step()
	}
}

#define custom_step
with(instances_matching_ne(instances_matching_ne([Bullet2, FlameShell, HeavySlug, UltraShell, Slug], "ShatteredSkull", 1), "pg", 1)){
	ShatteredSkull = 1;
	if(damage >= 1){
		var rand = irandom(sqrt(damage)) * skill_get(mod_current)
		if(rand){
			repeat(rand){
				var split = instance_clone();
				split.team = team;
				split.direction = direction + random_range(-10, 10);
				split.image_angle = direction;
				split.ShatteredSkull = 1;
				split.speed = 7.5;
				split.Cellulite = 1;
			}
		}
	}
}
with(instances_matching_ne(CustomProjectile, "ShatteredSkull", 1)){
	ShatteredSkull = 1;
	if(("is_slug" in self && is_slug || "is_shell" in self && is_shell) && damage >= 1){
		var rand = irandom(sqrt(damage)) * skill_get(mod_current);
		if(rand){
			repeat(rand){
				var split = instance_clone();
				split.team = team;
				split.direction = direction + random_range(-10, 10);
				split.ShatteredSkull = 1;
				split.speed = 7.5;
				split.Cellulite = 1;
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
	

#define stall_shell_step
	if !instance_exists(self){
		return;
	}
	if "cellulite_init" not in self {
		cellulite_init		= true;
		cellulite_frames	= random_range(10,30) + 60 * skill_get(mod_current);
		cellulite_max		= cellulite_frames;
		setback 			= 0;
		faux_friction		= friction;
		friction			= 0;
		start_xscale		= image_xscale;
		start_yscale		= image_yscale;
		image_xscale		*= xs_srt;
		image_yscale		*= ys_srt;
		speed				*= 1.2;
		
		if "wallbounce" not in self wallbounce = 0;
		
		
		if !wallbounce {
			safebounce = false;
			wallbounce ++;
		}
		else safebounce = true;
	}

	if cellulite_frames {
		prev_speed = speed;
		setback = min(setback + faux_friction * current_time_scale, prev_speed);
		
		//shells that coudn't bounce prior will just hug the wall
		//makes flame shells and toxic flechettes more effective
		if !wallbounce && !safebounce {
			setback = prev_speed;
			x = xprevious;
			y = yprevious;
		}

		var t = (setback/prev_speed);
		image_xscale = start_xscale * lerp(xs_srt,xs_end,t);
		image_yscale = start_yscale * lerp(ys_srt,ys_end,t);
		
		if setback + current_time_scale >= prev_speed {
			direction += current_time_scale*30;
			image_angle += current_time_scale*30;
		}
		
		if setback == prev_speed {
			cellulite_frames -= current_time_scale;
			// var t = 1 - (cellulite_frames/cellulite_max);
			// image_xscale = start_xscale * lerp(xs_srt,xs_end,t);
			// image_yscale = start_yscale * lerp(ys_srt,ys_end,t);
			
			bonus = max(bonus,2); //shells deal more damage when stationary
			
			if !cellulite_frames {
				x += hspeed_raw;
				y += vspeed_raw;
				speed = 0;
				sound_play_pitchvol(sndFlakExplode,4 + random(1),0.15);
			}
		}
		
		//stall projectile without actually slowing it
		x -= lengthdir_x(setback * current_time_scale,direction);
		y -= lengthdir_y(setback * current_time_scale,direction);
	}

#macro xs_srt		1.2
#macro ys_srt		0.7

#macro xs_end		0.5		
#macro ys_end		1.15