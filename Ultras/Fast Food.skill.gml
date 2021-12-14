#define init
	global.sprButton = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillAnim = noone; 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "FAST FOOD";
#define skill_text    return "EATING WEAPONS#GIVES TEMPORARY @wBUFFS@s";
#define skill_tip     return "I'll have a number 9,#two number sixes with extra dip...";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprButton;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "robot";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool

#define step
with(Player){
	with (RobotEat)
	{ 
		if (creator == other.id && "fastfood" not in self)
		{
			fastfood = 1;
			repeat(1 + skill_get(mut_throne_butt)){buff(creator);}
		}
	}
	with(instances_matching(instances_matching(projectile, "creator", self), "Double", 1)){
		Double = 2;
		with(instance_clone()){
			Double = 2;
			team = other.team;
			//damage = other.damage / global.modifier;
			if(object_index == BloodSlash){
				creator = -4;
			}
			if(object_index != Laser){
				var r = random_range(-15,15);
				direction += r;
				image_angle += r;
			}else{
				x -= lengthdir_x(image_xscale*2,direction);
				y -= lengthdir_y(image_xscale*2,direction);
				var r = random_range(-15,15);
				direction += r;
				image_angle += r;
				with instance_create(x,y,Laser){
					Double = 2;
					alarm0 = 1;
					image_angle = other.image_angle;
					hitid = [sprite_index, "LASER"];
					team = other.team;
					creator = other;
				}
				instance_destroy();
			}
		}
	}
}

#define buff(obj)
with(obj){
	var options = ["Reload", "Speed", "Double", "Poison", "Infinite Ammo", "Damage", "Reflect", "Invincibility", "Jackpot", "Reroll", "Welp.", "The Dud", "Aww.", "Better Luck Next Time?"];
	if(mod_script_exists("mod", "metamorphosis", "haste")){
		array_push(options, "Haste");
	}
	var r = options[irandom(array_length(options) - 1)];
	switch(r){
		case "Reload": reloadspeed += 0.5; if(fork()){wait(240){if(instance_exists(self)){reloadspeed -= 0.5;exit;}}} break;
		case "Speed": maxspeed += 1; if(fork()){wait(240){if(instance_exists(self)){maxspeed -= 1;exit;}}} break;
		case "Double": break;
		case "Poison": repeat(240){with(instance_create(x,y,Curse)){direction = random(360);speed = 5;}} break;
		case "Infinite Ammo": infammo += 240; break;
		case "Damage": break;
		case "Reflect": break;
		case "Invincibility": nexthurt = current_frame + 240; break;
		case "Jackpot": repeat(4){buff(obj)} break;
		case "Reroll": instance_create(x,y,WepPickup).wep = weapon_decide(0, 1 + (2 * curse) + GameCont.hard, false, null); break;
		case "Haste": haste(5, 5); break;
	}
	with(instance_create(x,y, PopupText)){
		text = r;
	}
	if(fork()){
		repeat(240){
			if(instance_exists(self)){
				switch(r){
					case "Reload": 
						with(instance_create(x,y,CaveSparkle)){
							direction = random(360);
							speed = 1;
						}
						break;
					case "Speed": 
						with(instance_create(x,y,Dust)){
							direction = random(360);
							speed = 1;
						}
						break;
					case "Double": 
						with(instance_create(x,y,ThrowHit)){
							direction = random(360);
							speed = 1;
						}
						with(instances_matching(instances_matching(projectile, "creator", self), "Double", null)){
							Double = 1;
						}
						break;
					case "Poison": 
						with(instances_matching_ne(enemy, "team", team)){
							if(distance_to_object(Player) < 200){
								my_health-=0.1;
								var fx = instance_create(x,y,Curse);
									fx.direction = random(360);
									fx.speed = 1;
							}
						}
						break;
					case "Infinite Ammo": 
						break;
					case "Damage": 
						with(instances_matching(instances_matching(projectile, "creator", self), "FFDamage", null)){
							FFDamage = 1;
							damage *= 2;
						}
						with(instance_create(x,y,AllyDamage)){
							direction = random(360);
							image_angle = direction;
						}
						break;
					case "Reflect": 
						with(instances_matching_ne(projectile, "team", team)){
							if(distance_to_object(Player) < 50){
								team = other.team;
								direction += 180;
								image_angle += 180;
							}
						}
						with(instance_create(x,y,Deflect)){
							direction = random(360);
							image_angle = direction;
							speed = 1;
						}
						break;
					case "Invincibility": 
						with(instance_create(x,y,WepSwap)){
							direction = random(360);
							speed = 1;
						}
					case "Jackpot": 
						with(instance_create(x,y,FireFly)){
							direction = random(360);
							speed = 1;
						}
						break;
					case "Haste": 
						if(speed > 0 and (current_frame mod (current_time_scale * 2)) = 0) { 
							with(instance_create(x - (hspeed * 2) + random_range(-3, 3), y - (vspeed * 2) + random_range(-3, 3), BoltTrail)) {
								creator = other; 
								image_angle = other.direction;
								image_yscale = 1.4;
								image_xscale = other.speed * 4;
							}
						}
						break;
				}
			}
			wait(1);
		}
	}
}

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
	
//Yokin script
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)
	/*
		Returns a random weapon that spawns within the given difficulties
		Takes standard weapon chest spawning conditions into account
		
		Args:
			hardMin - The minimum weapon spawning difficulty
			hardMax - The maximum weapon spawning difficulty
			gold    - Spawn golden weapons like a mansion chest, true/false
			          Use -1 to completely exclude golden weapons
			noWep   - A weapon or array of weapons to exclude from spawning
			
		Ex:
			wep = weapon_decide(0, 1 + (2 * curse) + GameCont.hard, false, null);
			wep = weapon_decide(2, GameCont.hard, false, [p.wep, p.bwep]);
	*/
	
	 // Hardmode:
	_hardMax += ceil((GameCont.hard - (UberCont.hardmode * 13)) / (1 + (UberCont.hardmode * 2))) - GameCont.hard;
	
	 // Robot:
	for(var i = 0; i < maxp; i++){
		if(player_get_race(i) == "robot"){
			_hardMax++;
		}
	}
	_hardMin += 5 * ultra_get("robot", 1);
	
	 // Just in Case:
	_hardMax = max(0, _hardMax);
	_hardMin = min(_hardMin, _hardMax);
	
	 // Default:
	var _wepDecide = wep_screwdriver;
	if("wep" in self && wep != wep_none){
		_wepDecide = wep;
	}
	else if(_gold > 0){
		_wepDecide = choose(wep_golden_wrench, wep_golden_machinegun, wep_golden_shotgun, wep_golden_crossbow, wep_golden_grenade_launcher, wep_golden_laser_pistol);
		if(GameCont.loops > 0 && random(2) < 1){
			_wepDecide = choose(wep_golden_screwdriver, wep_golden_assault_rifle, wep_golden_slugger, wep_golden_splinter_gun, wep_golden_bazooka, wep_golden_plasma_gun);
		}
	}
	
	 // Decide:
	var	_list    = ds_list_create(),
		_listMax = weapon_get_list(_list, _hardMin, _hardMax);
		
	ds_list_shuffle(_list);
	
	for(var i = 0; i < _listMax; i++){
		var	_wep    = ds_list_find_value(_list, i),
			_canWep = true;
			
		 // Weapon Exceptions:
		if(_wep == _noWep || (is_array(_noWep) && array_find_index(_noWep, _wep) >= 0)){
			_canWep = false;
		}
		
		 // Gold Check:
		else if((_gold > 0 && !weapon_get_gold(_wep)) || (_gold < 0 && weapon_get_gold(_wep) == 0)){
			_canWep = false;
		}
		
		 // Specific Spawn Conditions:
		else switch(_wep){
			case wep_super_disc_gun       : if("curse" not in self || curse <= 0) _canWep = false; break;
			case wep_golden_nuke_launcher : if(!UberCont.hardmode)                _canWep = false; break;
			case wep_golden_disc_gun      : if(!UberCont.hardmode)                _canWep = false; break;
			case wep_gun_gun              : if(crown_current != crwn_guns)        _canWep = false; break;
		}
		
		 // Success:
		if(_canWep){
			_wepDecide = _wep;
			break;
		}
	}
	
	ds_list_destroy(_list);
	
	return _wepDecide;

#define haste(amt, pow)                                            	    		return mod_script_call('mod', 'metamorphosis', 'haste', amt, pow);