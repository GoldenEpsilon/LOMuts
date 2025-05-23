#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.sprCanister = sprite_add("../Sprites/PortalCanister.png", 3, 8, 10)
global.spawnChest = false;
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Wormhole Eyes";
	
#define skill_text
	return 'Portal Canisters spawn,#which restart the level (leaving enemies dead and chests opened)';

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "@qI CAN SEE YESTERDAY";
	
#define skill_type
	return "outcast";
	
#define skill_take(_num)
	sound_play(sndMut);

#define step
	if(instance_exists(GenCont)){
		global.spawnChest = true;
	}
	if(!instance_exists(GenCont) && global.spawnChest){
		global.spawnChest = false;
		with(call(scr.instance_random, Floor)){
			instance_create(x + sprite_width/2,y + sprite_height/2,CustomProp).sprite_index = global.sprCanister;
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call