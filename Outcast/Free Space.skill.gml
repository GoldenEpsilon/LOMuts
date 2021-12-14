#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.givenSkills = [];
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Free Space";
	
#define skill_text
	return "Get a random outcast mutation";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return false;

#define skill_outcast
	return true;

#define skill_tip
	return "Free Real Estate";
	
#define skill_take
	sound_play(sndMut);
	var _skills = mod_get_names("skill");
	var _outcasts = [];
	with(_skills){
		if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
			array_push(_outcasts, self);
		}
	}
	if(array_length(_outcasts)){
		var chosen = _outcasts[call(scr.seeded_random, GameCont.level + GameCont.mutindex, 0, array_length(_outcasts)-1, 1)]
		array_push(global.givenSkills, chosen);
		skill_set(chosen, 1);
	}else{
		trace("No muts left in outcast pool, refunding");
		GameCont.skillpoints++;
	}
	
#define skill_lose
	if(array_length(global.givenSkills)){
		skill_set(global.givenSkills[0], 1);
		global.givenSkills = call(scr.array_delete, global.givenSkills, 0);
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call