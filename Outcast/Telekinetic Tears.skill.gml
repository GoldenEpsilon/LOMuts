#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.sprDiscoLaser = sprite_add("../Sprites/DiscoLaser.png", 1, 2, 3)

#define skill_name
	return "Telekinetic Tears";
	
#define skill_text
	return "Shells are#@phoming@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_outcast
	return true;

#define skill_tip
	return "Sweat and tears#on every shell";
	
#define skill_take
	sound_play(sndMut);

#define step
with(Player){
	with(instances_matching(instances_matching(projectile, "ammo_type", 2), "creator", self)){
		homing();
	}
	with(instances_matching([Bullet2, FlameShell, HeavySlug, UltraShell, Slug, FlakBullet, SuperFlakBullet], "creator", self)){
		homing();
	}
}

#define homing
	if(instance_number(hitme)>0 && speed != 0){
		var nearest = noone,
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
				direction+=current_time_scale*10*skill_get(mod_current);
				image_angle+=current_time_scale*10*skill_get(mod_current);
			}
			else{
				direction-=current_time_scale*10*skill_get(mod_current);
				image_angle-=current_time_scale*10*skill_get(mod_current);
			}
		}
	}