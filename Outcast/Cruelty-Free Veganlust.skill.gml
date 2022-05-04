#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Crulety-Free Veganlust";
	
#define skill_text
	return "Props can drop pickups";

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
	with(prop){
		var _x = x;
		var _y = y;
		if(fork()){
			wait(0);
			if(!instance_exists(self)){
				with(instance_nearest(x,y,Corpse){pickup_drop(30, 0, 1);}
			}
			exit;
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call