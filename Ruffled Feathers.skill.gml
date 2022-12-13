#define init
global.sprSkillIcon = sprite_add("Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Ruffled Feathers";
	
#define skill_text
	return `+4 @wmutation options@s#@(color:${make_color_rgb(84, 58, 24)})outcast@s mutations appear#this rerolls at level @gultra@s`;

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Impressive, I know.#Very few can achieve a mastery of the sky.";
	
#define skill_take
	sound_play(sndMut);
	mod_variable_set("mod", "Extra Mutation Options", "extrastacks", mod_variable_get("mod", "Extra Mutation Options", "extrastacks") + 4);
	var _skills = mod_get_names("skill");
	with(_skills){
		if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
			skill_set_active(self, true);
		}
	}
	
#define skill_lose
	mod_variable_set("mod", "Extra Mutation Options", "extrastacks", mod_variable_get("mod", "Extra Mutation Options", "extrastacks") - 4);
	if(!skill_get(mod_current)){
		var _skills = mod_get_names("skill");
		with(_skills){
			if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
				skill_set_active(self, false);
			}
		}
	}

#define step
	if(GameCont.level >= 10){
		GameCont.skillpoints += skill_get(mod_current);
		skill_set(mod_current, 0);
		audio_sound_set_track_position(sound_play_pitchvol(sndMutant15Cnfm, 2.5, 0.2),0.4);
	}