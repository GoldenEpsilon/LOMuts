#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");
global.spawnChest = false;

#define skill_name
	return "Wormhole Eyes";
	
#define skill_text
	return 'Portal Canisters spawn,#which activate @w"start of level"@s effects#@qWIP';

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
	
#define skill_take(_num)
	sound_play(sndMut);

#define step
	if(instance_exists(GenCont)){
		global.spawnChest = true;
	}
	if(!instance_exists(GenCont) && global.spawnChest){
		global.spawnChest = false;
		with(call(scr.instance_random, Floor)){
			instance_create(x,y,Turret);
		}
	}
	if(instance_number(Turret) == 0){
		with(call(scr.instance_random, Floor)){
			instance_create(x,y,Turret);
		}
		for(var i = 0; !is_undefined(skill_get_at(i)); i++){
			var _skill = skill_get_at(i);
			if(is_string(_skill) && mod_script_exists("skill", _skill, "level_start")){
				mod_script_call("skill", _skill, "level_start");
			}
		}
		with(Player){
			if(is_string(mod_script_exists("race", race, "level_start"))){
				mod_script_call("race", race, "level_start");
			}
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call