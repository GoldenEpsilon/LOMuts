#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Leprosy.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Leprosy";
	
#define skill_text
	return "take one damage#reroll the random outcast mutation#(this does not take a mutation)";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return false;
	
#define skill_sacrifice return false; //metamorphosis compat thing

#define skill_tip
	return "I feel icky...";
	
#define skill_type
	return "reusable";

#define skill_temp
	return 1;

#define skill_reusable
	return 1;
	
#define skill_take(_num)
	sound_play(sndMut);
	var hasHealth = 0;
	with(Player){
		if(my_health > 1){
			hasHealth = 1;
			my_health = max(1, my_health - 1);
			lsthealth = my_health;
		}
	}
	if(hasHealth){
		var _skills = mod_get_names("skill");
		var _outcasts = [];
		with(_skills){
			if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast") && mod_script_exists("skill", self, "skill_avail") && mod_script_call("skill", self, "skill_avail")){
				array_push(_outcasts, self);
			}
		}
		var i = 0;
		while(!is_undefined(skill_get_at(i))){i++}
		while(i > 0 && (!is_string(skill_get_at(i)) || !mod_script_exists("skill", skill_get_at(i), "skill_outcast") || !mod_script_call("skill", skill_get_at(i), "skill_outcast"))){
			i--;
		}
		skill_set(skill_get_at(i), 0);
		if(array_length(_outcasts)){
			var chosen = _outcasts[call(scr.seeded_random, GameCont.level + GameCont.mutindex + Player.my_health, 0, array_length(_outcasts)-1, 1)]
			skill_set(chosen, 1);
		}else{
			trace("No muts left in outcast pool, refunding");
			my_health++;
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call