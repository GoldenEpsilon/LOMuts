#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getHooks"], "skill", mod_current);

#define skill_name
	return "Buckshot Back";
	
#define skill_text
	return "Bullets get @wUPGRADED@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return false;

#define skill_outcast
	return true;

#define skill_tip
	return "Can't stop the wiggles";
	
#define skill_take
	sound_play(sndMut);
	
#define update(_id)
	with(instances_matching_gt(UltraBullet, "id", _id)){
		damage = ceil(damage*1.5);
		image_xscale *= 1.5;
		image_yscale *= 1.5;
	}
	with(instances_matching_gt(HeavyBullet, "id", _id)){
		instance_change(UltraBullet, false);
		damage += 11;
	}
	with(instances_matching_gt(BouncerBullet, "id", _id)){
		instance_change(HeavyBullet, false);
		speed *= 2;
		damage += 3;
	}
	with(instances_matching_gt(Bullet1, "id", _id)){
		instance_change(BouncerBullet, false);
		rot = 0;
		bounce = 0;
		speed *= 0.5;
		damage += 1;
	}