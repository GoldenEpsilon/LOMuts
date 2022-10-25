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
	return true;

#define skill_outcast
	return true;


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
					image_xscale += 0.5;
					image_yscale += 0.5;
					break;
			}
		}
	}