#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Recurrent Neural Network";
	
#define skill_text
	return "@gPLASMA@w BOUNCES@s#MORE @gPLASMA@s WEAPONS";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Boing";
	
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
	if(roll == 1 && string_count("Plasma", name) == 0) {
		wep = weapon_random(weapon_get_area(wep), weapon_get_area(wep));
	}
}
with(Player){
	with(instances_matching(instances_matching([PlasmaBall, PlasmaBig, PlasmaHuge, CustomObject],"plasmabounce",null),"team",team)){
		plasmabounce = 0;
		if(object_index != CustomObject || "is_plasma" in self && is_plasma){
			plasmabounce = skill_get(mod_current);
		}
	}
	with(instances_matching(instances_matching_ge(projectile,"plasmabounce",1),"team",team)){
		if(place_meeting(x + hspeed, y + vspeed, Wall)){
			with instance_create(x, y, PlasmaImpact){team = other.team; creator = other}
			plasmabounce--;
			move_bounce_solid(false)
			image_angle = direction
			speed *= .75;
			image_xscale *= .75;
			image_yscale *= .75;
			sleep(5)
			view_shake_at(x, y, 5)
			direction += random_range(-2, 2);
			sound_play_pitch(skill_get(mut_laser_brain) = 1 ? sndPlasmaBigExplode : sndPlasmaBigExplodeUpg, random_range(1.5, 1.7))
			sound_play_pitchvol(sndPlasmaHit, 1, .6)
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