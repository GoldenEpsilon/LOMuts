#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Purist.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");
global.check = array_length(mod_get_names("weapon")) > 30;

#define skill_name
	return "Purist";
	
#define skill_text
	return "More @wvanilla@s weapons";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return global.check;

#define skill_outcast
	return true;

#define skill_tip
	return "Inexperimental";
	
#define skill_take
	sound_play(sndMut);
	
#define update(_id)
	with(instances_matching_ne(instances_matching_gt(WepPickup, "id", _id), "ammo", 0)){
		repeat(2 * skill_get(mod_current)){
			if(!is_real(wep)){
				wep = weapon_decide(0, (ammo > 0) + (2 * curse) + GameCont.hard, false, null);
			}
		}
	}

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

#macro call script_ref_call
#macro scr global.scr