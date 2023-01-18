#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Buckshot Back.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Buckshot Back Icon.png", 1, 8, 8)
global.sprUpgUltraBullet = sprite_add("../Sprites/UpgradedUltraBullet.png", 2, 12, 12)
global.sprUpgUltraBullet2 = sprite_add("../Sprites/UpgradedUltraBullet2.png", 2, 12, 12)
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
	return true;

#define skill_outcast
	return true;
	
#define skill_wepspec
	return 1;


#define skill_tip
	return "You don't wanna know#what it costs to fire this gun.";
	
#define skill_take
	sound_play(sndMut);
	
#define update(_id)
	with(instances_matching_gt([Bullet1, BouncerBullet, HeavyBullet, UltraBullet], "id", _id)){
		repeat(skill_get(mod_current)){
			switch(object_index){
				case Bullet1:
					instance_change(BouncerBullet, false);
					rot = 5;
					bounce = 0;
					speed *= 0.5;
					damage += 1;
					break;
				case BouncerBullet:
					instance_change(HeavyBullet, false);
					speed *= 2;
					damage += 3;
					break;
				case HeavyBullet:
					instance_change(UltraBullet, false);
					damage += 11;
					break;
				case UltraBullet:
					damage += 10;
					if(sprite_index == global.sprUpgUltraBullet){
						sprite_index = global.sprUpgUltraBullet2;
					}else if(sprite_index == sprUltraBullet){
						sprite_index = global.sprUpgUltraBullet;
					}else{
						image_xscale += 0.25;
						image_yscale += 0.25;
					}
					break;
			}
		}
	}
	with(instances_matching_gt(instances_matching(CustomProjectile, "is_bullet", 1), "id", _id)){
		if("buckshot_upgrade" in self){
			script_ref_call(buckshot_upgrade, x, y);
			instance_destroy();
		}else{
			damage *= 1.5;
			damage = ceil(damage);
			image_xscale += 0.5;
			image_yscale += 0.5;
		}
	}