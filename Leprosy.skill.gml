#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Leprosy";
	
#define skill_text
	return "-2 max hp#gain a random outcast mutation#(this does not take a mutation)";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_sacrifice return false; //metamorphosis compat thing

#define skill_avail
	return instance_exists(Loadout);

#define skill_tip
	return "I feel icky...";

#define skill_temp
	return 1;

#define skill_reusable
	return 1;
	
#define skill_take(_num)
	sound_play(sndMut);
	var hasHealth = 0;
	with(Player){
		if(maxhealth > 2){
			hasHealth = 1;
			maxhealth = max(1, maxhealth - 2);
			prevhealth = my_health;
			if(my_health > maxhealth){my_health = maxhealth;lsthealth = maxhealth;}
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
		if(array_length(_outcasts)){
			var chosen = _outcasts[call(scr.seeded_random, GameCont.level + GameCont.mutindex, 0, array_length(_outcasts)-1, 1)]
			skill_set(chosen, 1);
			with(SkillIcon){
				if(skill == mod_current){
					skill = "Leprosy2";
					text = mod_script_call("skill", "Leprosy2", "skill_text");
				}
			}
		}else{
			trace("No muts left in outcast pool, refunding");
			maxhealth += 2;
			my_health = prevhealth;
		}
	}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call