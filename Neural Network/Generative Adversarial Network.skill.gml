#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)
global.sprBurningLaser = sprite_add("../Sprites/BurningLaser.png", 6, 2, 3)

#define skill_name
	return "Generative Adversarial Network";
	
#define skill_text
	return "@wLasers@s @rBURN@s#and are @wWIDER@s";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Don't look into lasers, kids";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return true;
	
#define step
script_bind_step(custom_step, 0);
#define custom_step
with(instances_matching_ne(WepPickup, "neural", true)){
	neural = true;
	var name = weapon_get_name(wep);
	if(string_count("Laser", name) == 0) {
		wep = weapon_random(weapon_get_area(wep), weapon_get_area(wep));
	}
}
with(Laser){
	if(object_index != Laser){
		continue;
	}
	if("neural" not in self){
		neural = 1;
		image_yscale *= 1.2;
	}
	var laser = id;
	if(sprite_index == sprLaser){
		sprite_index = global.sprBurningLaser;
	}else if(sprite_index != global.sprBurningLaser){
		image_blend = make_color_rgb(255,125,0);
	}
	with(hitme){
		if(team != laser.team && place_meeting(x,y,laser)){
			with(instance_create(x,y,Flame)){
				damage *= 1 + 0.5*skill_get(mod_current);
				team = laser.team;
				direction = laser.direction;
			}
		}
	}
	if(skill_get("flamingpalms")){
		with(projectile){
			if(team != laser.team && place_meeting(x,y,laser)){
				with(instance_create(x,y,Flame)){
					damage *= 1 + 0.5*skill_get(mod_current);
					team = laser.team;
					direction = laser.direction;
				}
			}
		}
	}
	pyroflammable = true;
	if(skill_get("pyromania")){
		with(Corpse){
			if(place_meeting(x,y,laser)){
				with(instance_create(x,y,Flame)){
					damage *= 1 + 0.5*skill_get(mod_current);
					team = laser.team;
					direction = laser.direction;
				}
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