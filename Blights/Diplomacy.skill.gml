#define init
global.sprSkillIcon = sprite_add("../Sprites/Blights/Diplomacy.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Blights/Diplomacy Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Diplomacy";
	
#define skill_text
	return "Moving @wenemy projectiles@s#become @rbandit bullets@s#(Stacks increase damage)";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return false;

#define skill_blight
	return true;

#define skill_tip
	return "Maybe you CAN talk to the monsters...";
	
#define skill_take
	sound_play(sndMut);

#define step
	
#define update(_id)
	with(Player){
		with(instances_matching_ne(instances_matching_ne(instances_matching_gt(instances_matching_gt(instances_matching_ne(instances_matching_gt(projectile, "id", _id), "ammo_type", -1), "speed", 0), "damage", 0), "team", 0), "team", team)){
			instance_change(EnemyBullet1, false);
			damage = (damage + (2+skill_get(mod_current))*(skill_get(mod_current)-1))/skill_get(mod_current);
			speed = (speed + 4*(skill_get(mod_current)-1))/skill_get(mod_current);
			image_angle = direction;
			image_xscale *= (0.5+min(max(damage/3, 0.9), 10))/1.5;
			image_yscale *= (0.5+min(max(damage/3, 0.9), 10))/1.5;
			friction = 0;
			typ = 1;
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call