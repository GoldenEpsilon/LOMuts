#define init
global.sprSkillIcon = sprite_add("Sprites/Outcast/Buckshot Back.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Outcast/Buckshot Back Icon.png", 1, 8, 8)
global.sprUpgUltraBullet = sprite_add("Sprites/UpgradedUltraBullet.png", 2, 12, 12)
global.sprUpgUltraBullet2 = sprite_add("Sprites/UpgradedUltraBullet2.png", 2, 12, 12)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getHooks"], "skill", mod_current);

#define skill_name
	return "Buckshot Back";
	
#define skill_text
	return "Bullets have a @w33%@s chance#to get @wUPGRADED@s";
	
#define stack_text
	return "@wUPGRADES@s GET ROLLED#MORE THAN ONCE";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;
	
#define skill_wepspec
	return 1;
	
#define skill_outcast
	return true;

#define skill_tip
	return "You don't wanna know#what it costs to fire this gun.";
	
#define skill_type
	return "outcast";
	
#define skill_take
	sound_play(sndMut);
	
#define update(_id)
	repeat(skill_get(mod_current)){
		with(instances_matching_gt([Bullet1, HeavyBullet, UltraBullet], "id", _id)){
			if(irandom(2) == 0){
				if "buckshotupgrade" not in self {
					buckshotupgrade = 1;
				}else {
					buckshotupgrade++;
				}
			}
		}
		with(instances_matching_gt(BouncerBullet, "id", _id)){
			if(irandom(2) == 0){
				damage *= 2;
				damage = ceil(damage);
				image_xscale += 0.5;
				image_yscale += 0.5;
			}
		}
		with(instances_matching_gt(instances_matching(CustomProjectile, "is_bullet", 1), "id", _id)){
			if(irandom(2) == 0){
				if("buckshot_upgrade" in self){
					script_ref_call(buckshot_upgrade, x, y);
				}else{
					damage *= 2;
					damage = ceil(damage);
					image_xscale += 0.5;
					image_yscale += 0.5;
				}
			}
		}
	}
	with(instances_matching_gt([Bullet1, HeavyBullet, UltraBullet], "buckshotupgrade", 0)){
		repeat(buckshotupgrade){
			switch(object_index){
				case Bullet1:
					instance_change(HeavyBullet, false);
					damage += 4;
					break;
				case HeavyBullet:
					instance_change(UltraBullet, false);
					damage += 11;
					break;
				case UltraBullet:
					damage += 20;
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
		buckshotupgrade = 0;
	}