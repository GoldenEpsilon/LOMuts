#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "ENLIGHTENMENT";
#define skill_text    return "THROWN WEAPONS @wHOME@s";
#define skill_tip     return "@qI'M MARY POPPINS Y'ALL";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "chicken";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool

#define step
with(ThrownWep){
	if(instance_number(hitme)>0 && speed != 0){
		if("prevSpeed" not in self){prevSpeed = speed;}
		speed = (speed + prevSpeed) / 2;
		prevSpeed = speed;
		var	nearest = noone,
			dist = -1;

		with(instances_matching_ne(instances_matching_ne(hitme,"team",team), "team", 0)){
			var tempDist = point_distance(other.x, other.y, x, y);
			if(tempDist < dist || dist == -1){
				nearest = id;
				dist = tempDist;
			}
		}
		if(nearest > 0){
			if(abs(angle_difference(point_direction(x,y,nearest.x,nearest.y), direction)) <= current_time_scale*10){
				direction = point_direction(x,y,nearest.x,nearest.y);
				image_angle = point_direction(x,y,nearest.x,nearest.y);
			}
			else if(angle_difference(point_direction(x,y,nearest.x,nearest.y), direction) > 0){
				direction+=current_time_scale*15;
				image_angle+=current_time_scale*15;
			}
			else{
				direction-=current_time_scale*15;
				image_angle-=current_time_scale*15;
			}
		}
	}
}