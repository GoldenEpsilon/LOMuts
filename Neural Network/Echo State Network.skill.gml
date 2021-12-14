#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Echo State Network";
	
#define skill_text
	return "@bElectricity@s jumps between @wenemies@s";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Gettin' Grounded";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return true;
	
#define step

with(Lightning){
	var enem = instance_nearest(x,y,enemy);
	if(enem != -4 && distance_to_point(enem.x,enem.y) < 10 + 10 * skill_get(mod_current)){
		x = enem.x;
		y = enem.y;
	}
}