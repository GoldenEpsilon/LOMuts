#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Toxic Thoughts.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Toxic Thoughts Icon.png", 1, 8, 8)

#define skill_name
	return "Toxic Thoughts";
	
#define skill_text
	return "@wToxic clouds@s move towards enemies";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_outcast
	return true;

#define skill_avail
	return true;

#define skill_tip
	return choose("Blame the player#not the game", "Indifferent to ballguys");
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	
#define step

var list = [];
repeat(min(50, instance_number(ToxicGas))){
	array_push(list, irandom(instance_number(ToxicGas)));
}
array_sort(list, true);
var i = -1;
var i2 = 0;
with(ToxicGas){
	i++;
	if(i == list[i2]){
		while(i == list[i2] && i2 + 1 < array_length(list)){
			i2++;
		}
	}else{
		continue;
	}
	if(speed > 3){
		continue;
	}
	var nearestEnemy = instance_nearest(x,y,enemy);
	if(nearestEnemy == -4 ||nearestEnemy.object_index == FrogQueen || nearestEnemy.object_index == SuperFrog || nearestEnemy.object_index == Exploder){
		continue;
	}
	var _x = nearestEnemy.x;
	var _y = nearestEnemy.y;
	var d = distance_to_point(nearestEnemy.x, nearestEnemy.y);
	if(nearestEnemy != -4 && d < 100){
		motion_add(point_direction(x, y, _x, _y), 0.5 * skill_get(mod_current));
	}
	//speed = min(speed, power(image_xscale, 1.5)*6);
}