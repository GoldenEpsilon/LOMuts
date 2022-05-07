#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Friendly Eyelashes";
	
#define skill_text
	return "When an enemy is under half health,#there's a chance it gets marked.#marked enemies are charmed";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return mod_exists("mod", "telib");

#define skill_outcast
	return true;

#define skill_tip
	return "*flutter flutter*";
	
#define skill_take(_num)
	sound_play(sndMut);

#define step
	with(instances_matching_ne(enemy, "markcheck", true)){
		if(my_health < maxhealth / 2){
			markcheck = true;
			if(irandom(9 / skill_get(mod_current)) == 0){
				marked = true;
			}
		}
	}
	with(instances_matching(instances_matching_ne(enemy, "markedcharm", true), "marked", true)){
		markedcharm = true;
		mod_script_call("race", "parrot", "charm_instance_raw", self, true).time = 135 + skill_get(mod_current) * 15;
	}
