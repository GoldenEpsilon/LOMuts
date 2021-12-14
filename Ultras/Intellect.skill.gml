#define init
	global.sprButton = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "INTELLECT";
#define skill_text    return "PRIMARY WEAPON HAS @wACCURACY@s#SECONDARY WEAPON HAS @wAUTOAIM@s";
#define skill_tip     return "Putting it to good use";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprButton;
#define skill_take    with Player {if(race == "steroids" || mod_script_call("skill", "Mimicry", "ultra_get", mod_current)){accuracy /= 2;}} if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_lose    with Player {if(race == "steroids" || mod_script_call("skill", "Mimicry", "ultra_get", mod_current)){accuracy *= 2;}}
#define skill_ultra   return "steroids";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
#define skill_mimicry return true;

#define step
//gonna straight up yoink a lot of this from autopop because yeah, thanks burg
with Player if ((race == "steroids" || mod_script_call("skill", "Mimicry", "ultra_get", mod_current)) && button_check(index,"spec") && canspec && bwep != 0) {
	var _t = weapon_get_type(bwep);
	var _c = weapon_get_cost(bwep);
	var _l = weapon_get_load(bwep);
	var _a = infammo;
	var tempwep;
	var tempreload;
	specfiring = 1
	while (breload <= 0 && (ammo[_t] >= (_c) || _a != 0)){
	    tempwep = wep;
	    tempreload = reload;
	    tempwkick = wkick;
		wep = bwep;
		bwep = tempwep;
		reload = breload;
		breload = tempreload;
		wkick = bwkick;
		bwkick = tempwkick;
		var dir = gunangle;
		if(instance_exists(enemy)){
			var _e = instance_nearest(x,y,enemy);
			dir = point_direction(x,y,_e.x,_e.y);
		}
		accuracy *= 2;
		player_fire(dir);
		if(!instance_exists(self)){exit;}
		accuracy /= 2;
	    tempwep = wep;
	    tempreload = reload;
	    tempwkick = wkick;
		wep = bwep;
		bwep = tempwep;
		reload = breload;
		breload = tempreload;
		wkick = bwkick;
		bwkick = tempwkick;
	}
	specfiring = 0
}