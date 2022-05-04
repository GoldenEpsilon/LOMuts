#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getHooks"], "skill", mod_current);

#define skill_name
	return "Wiggle Waist";
	
#define skill_text
	return "All projectiles @q@wWiggle@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Can't stop the wiggles";
	
#define skill_take
	sound_play(sndMut);

#define step
	with(instances_matching_ge(projectile, "wiggle", 1)){
		wiggle += current_time_scale*speed;
		image_angle -= dsin(prevWiggle*4/skill_get(mod_current))*30*skill_get(mod_current);
		direction -= dsin(prevWiggle*4/skill_get(mod_current))*30*skill_get(mod_current);
		image_angle += dsin(wiggle*4/skill_get(mod_current))*30*skill_get(mod_current);
		direction += dsin(wiggle*4/skill_get(mod_current))*30*skill_get(mod_current);
		prevWiggle = wiggle;
	}
	
#define update(_id)
	with(instances_matching_gt(instances_matching_gt(instances_matching_ne(instances_matching_gt(projectile, "id", _id), "ammo_type", -1), "speed", 0), "damage", 0)){
		wiggle = 1+irandom(1)*180*skill_get(mod_current)/4;
		prevWiggle = wiggle;
	}