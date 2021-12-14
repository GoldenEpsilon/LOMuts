#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Deep Convolutional Network";
	
#define skill_text
	return `@(color:${c_orange})Quazar@s beams are @pHOMING@s`;

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "QUAZAR GO @qBRRR@qRRR";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return "telib";
	
#define step
script_bind_step(custom_step, 0);
#define custom_step
with(Player){
	if(instance_exists(enemy)){
		with(instances_matching(instances_matching(CustomProjectile,"name","QuasarBeam"),"team",team)){
			var _l = other;
			if(array_length(line_seg)){
				_l = line_seg[array_length(line_seg) - 1];
			}
			var _e = instance_nearest(_l.x,_l.y,enemy);
			var _angle = point_direction(other.x,other.y,_e.x,_e.y);
			if(_angle != null){
				var _turn = angle_difference(_angle, image_angle);
				if(abs(_turn) > 90 && abs(_angle) > 1){
					_turn = abs(_turn) * sign(_angle);
				}
				bend += clamp(_turn, -5 * skill_get(mod_current), 5 * skill_get(mod_current)) * current_time_scale;
			}
		}
	}
}
instance_destroy();