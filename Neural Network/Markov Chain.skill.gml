#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Markov Chain";
	
#define skill_text
	return "@pElectroplasma@s tethers to @wenemies@s";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Break your chains# - they can't";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return "telib";
	
#define step
if(instance_exists(enemy) && instance_exists(Player)){
	with(instances_matching(instances_matching(CustomProjectile, "name", "ElectroPlasma"),"team",Player.team)){
		var _e = instance_nearest(x,y,enemy);
		var	_x1 = x + hspeed_raw,
			_y1 = y + vspeed_raw,
			_x2 = _e.x,
			_y2 = _e.y;
			
		if(point_distance(_x1, _y1, _x2, _y2) < tether_range * skill_get(mod_current) / 2
			&& !collision_line(_x1, _y1, _x2, _y2, Wall, false, false)
		){
			var	_d = direction;
			with(mod_script_call_self('mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, (point_distance(_x1, _y1, _x2, _y2) / 4) * sin(wave / 90), false)){
				damage       = floor(other.damage * 7/3);
				sprite_index = mod_variable_get("mod", "tetrench", "spr").ElectroPlasmaTether;
				depth        = -3;
				
				 // Effects:
				if(random(16) < (1 * current_time_scale)){
					with(instance_create(x, y, PlasmaTrail)){
						sprite_index = mod_variable_get("mod", "tetrench", "spr").ElectroPlasmaTrail;
						motion_set(_d, 1);
					}
				}
			}
		}
	}
}