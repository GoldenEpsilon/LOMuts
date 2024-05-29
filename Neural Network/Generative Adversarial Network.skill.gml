#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Generative Adversarial Network";
	
#define skill_text
	return "@wLasers@s pierce @wEVERYTHING@s#Short range lasers";
	
#define stack_text
	return "More Range";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Interdimensional Lasers";
	
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
with(Laser){
	if(object_index != Laser){
		continue;
	}
	depth = -10;
	var dist = 100 * skill_get(mod_current);
	x += lengthdir_x(dist*2-image_xscale*2, image_angle);
	y += lengthdir_y(dist*2-image_xscale*2, image_angle);
	image_xscale = dist;
}
instance_destroy();