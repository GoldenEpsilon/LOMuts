#define init
global.sprSkillIcon = sprite_add("Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Ruffled Feathers";
	
#define skill_text
	return "+2 @wmutation options@s#outcast mutations appear#in the mutation pool.";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Impressive, I know.#Very few can achieve a mastery of the sky.";
	
#define skill_take
	sound_play(sndMut);
	mod_variable_set("mod", "Extra Mutation Options", "extrastacks", mod_variable_get("mod", "Extra Mutation Options", "extrastacks") + 2);
	var _skills = mod_get_names("skill");
	with(_skills){
		if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
			skill_set_active(self, true);
		}
	}
	
#define skill_lose
	mod_variable_set("mod", "Extra Mutation Options", "extrastacks", mod_variable_get("mod", "Extra Mutation Options", "extrastacks") - 2);
	if(!skill_get(mod_current)){
		var _skills = mod_get_names("skill");
		with(_skills){
			if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
				skill_set_active(self, false);
			}
		}
	}