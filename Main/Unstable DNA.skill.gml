#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Unstable DNA.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Unstable DNA Icon.png", 1, 8, 8)
global.last_took = []; 
global.last_race = [];

#define skill_name
	return "Unstable DNA";
	
#define skill_text
	return "Gain an @gULTRA@s#lose half your @rmax HP@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_sacrifice return false; //metamorphosis compat thing

#define skill_avail
	var healthy = true;
	with Player {
		if maxhealth < 6 {
			healthy = false;
		}
	}
	return healthy && (!instance_is(self, CustomObject) && !instance_is(self, CustomProp)) || instance_exists(Loadout);

#define skill_tip
	return "I don't feel so good...";
	
#define skill_type
	return "utility";

#define skill_temp
	return 1;
	
#define skill_take
	sound_play(sndMutOpenMind);

	 // Obtain Ultra:
	GameCont.endpoints++;

	with Player {
		maxhealth = ceil(maxhealth / 2);
		if(my_health > maxhealth){my_health = maxhealth;lsthealth = maxhealth;}
	}

#define step
	with(instances_matching(mutbutton, "object_index", SkillIcon, EGSkillIcon)) {
		if((object_index = EGSkillIcon) or (is_string(skill) and mod_script_exists("skill", skill, "skill_ultra"))) {
			if((!is_string(skill) and ultra_get(race, skill)) or (object_index != EGSkillIcon and is_string(skill) and skill_get(skill))) {
				 // Check to see what ultra this chump took:
				if(instance_exists(self)) {
					if(fork()) {
						var _skill = skill;
						
						if(object_index = EGSkillIcon) var _race = race; 
						else var _race = -1;
						
						wait 1;
						
						if(!instance_exists(self) and ((!is_string(_skill) and ultra_get(_race, _skill)) or skill_get(_skill))) {
							array_push(global.last_race, _race);
							array_push(global.last_took, _skill);
						}
						
						exit;
					}
				}
			}
		}
	}

#define skill_lose
	with Player {
		maxhealth = floor(maxhealth * 2);
	}
	
	for(i = 0; i < array_length(global.last_took); i++) {
		ultra_set(global.last_race[i], global.last_took[i], 0);
		skill_set(global.last_took[i], 0);
	}
	
	global.last_race = [];
	global.last_took = [];