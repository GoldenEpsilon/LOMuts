#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Cruelty-Free Veganlust.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Cruelty-Free Veganlust Icon.png", 1, 8, 8)
global.CFVAmmo = sprite_add_weapon("../Sprites/CrueltyFreeVeganlustAmmo.png", 5, 5);
global.CFVHealth = sprite_add_weapon("../Sprites/CrueltyFreeVeganlustHealth.png", 5, 5);
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Cruelty-Free Veganlust";
	
#define skill_text
	return "Props can drop @wpickups@s#(while enemies exist)";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Cactus salad#yummy yummy";
	
#define skill_take(_num)
	sound_play(sndMut);

#define step
	if(instance_exists(enemy)){
		with(prop){
			var _x = x;
			var _y = y;
			if(fork()){
				wait(0);
				if(!instance_exists(self)){
					var newID = real(instance_create(0, 0, DramaCamera));
					repeat(skill_get(mod_current)){
						with(instance_nearest(_x,_y,Corpse)){pickup_drop(50, 0, 1);}
					}
					with(instances_matching_ge(AmmoPickup, "id", newID)){
						if(sprite_index == sprAmmo){
							sprite_index = global.CFVAmmo;
						}
					}
					with(instances_matching_ge(HPPickup, "id", newID)){
						if(sprite_index == sprHP){
							sprite_index = global.CFVHealth;
						}
					}
				}
				exit;
			}
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call