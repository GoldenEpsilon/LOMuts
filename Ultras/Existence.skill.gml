#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "EXISTENCE";
#define skill_text    return "BLOOD EXPLOSIONS#@wMOVE@s TOWARDS ENEMIES";
#define skill_tip     return "THE PAIN FINDS YOU";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "melting";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
#define skill_mimicry return true;

#define step
with(MeatExplosion) {
	image_speed = 0.25;
	if(instance_number(hitme)>0){
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
			move_contact_solid(point_direction(x,y,nearest.x,nearest.y), 4);
		}
	}
}