#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Support Vector Machines";
	
#define skill_text
	return `@(color:${c_aqua})Vectors@s are @wwider@s`;

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Support your local#vector machines today!";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return "defpack tools";
	
#define step
script_bind_step(custom_step, 0);
#define custom_step
with(Player){
	with(instances_matching(instances_matching(CustomProjectile,"vectormachine",null),"team",team)){
		vectormachine = 1;
		if("name" in self && is_string(name) && name == "Vector"){
			image_xscale *= 2 * skill_get(mod_current);
			defbloom.yscale *= 2 * skill_get(mod_current)/1.5;
			image_yscale *= 1.5 * skill_get(mod_current);
		}
	}
	with(instances_matching(instances_matching(CustomProjectile,"name","vector beam"),"team",team)){
		image_yscale *= 2 * skill_get(mod_current);
	}
}
instance_destroy();