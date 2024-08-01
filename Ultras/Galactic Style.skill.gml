#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "GALACTIC STYLE";
#define skill_text    return "TELEKINESIS PULLS#@wEVERYTHING@s TO YOUR CURSOR";
#define skill_tip     return "One with the universe";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "eyes";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool

#define step
with(Player){
	if(button_check(index, "spec")){
		//I'mma counteract the regular telekinesis with x10 code
		var d, _x, _y, tb = -(0.5+skill_get(mut_throne_butt))*current_time_scale;
		// pull all the things:
		with (instances_matching([enemy, chestprop, HPPickup, AmmoPickup, WepPickup, Rad, BigRad, RadChest], "", null)){
			d = point_direction(x, y, other.x, other.y);
			_x = x + lengthdir_x(tb, d);
			_y = y + lengthdir_y(tb, d);
			if (place_free(_x, y)) x = _x;
			if (place_free(x, _y)) y = _y;
		}
		// push enemy projectiles away:
		with (projectile) if (team != other.team && object_index != EnemyLaser) {
			d = point_direction(x, y, other.x, other.y);
			_x = x - lengthdir_x(tb, d);
			_y = y - lengthdir_y(tb, d);
			if (place_free(_x, y)) x = _x;
			if (place_free(x, _y)) y = _y;
		}
		
		//then use that same code to pull to the cursor!
		var d, _x, _y, tb = (1+skill_get(mut_throne_butt))*current_time_scale;
		// pull all the things:
		with (instances_matching([enemy, chestprop, HPPickup, AmmoPickup, WepPickup, Rad, BigRad, RadChest], "", null)){
			d = point_direction(x, y, mouse_x[other.p], mouse_y[other.p]);
			_x = x + lengthdir_x(tb, d);
			_y = y + lengthdir_y(tb, d);
			if (place_free(_x, y)) x = _x;
			if (place_free(x, _y)) y = _y;
		}
		// pull enemy projectiles in:
		with (projectile) if (team != other.team && object_index != EnemyLaser) {
			d = point_direction(x, y, mouse_x[other.p], mouse_y[other.p]);
			_x = x + lengthdir_x(tb, d);
			_y = y + lengthdir_y(tb, d);
			if (place_free(_x, y)) x = _x;
			if (place_free(x, _y)) y = _y;
		}
	}
}