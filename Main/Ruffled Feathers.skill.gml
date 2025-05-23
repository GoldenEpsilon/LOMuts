#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Ruffled Feathers.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Ruffled Feathers Icon.png", 1, 8, 8)
global.stacks = 0;

#define game_start
	global.stacks = 0;

#define skill_name
	return "Ruffled Feathers";
	
#define skill_text
	return `+2 @gmutation@s options#@(color:${make_color_rgb(84, 58, 24)})outcast@s @gmutations@s appear#this rerolls at level @gultra@s`;

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Impressive, I know.#Very few can achieve a mastery of the sky.";
	
#define skill_type
	return "utility";
	
#define skill_take
	sound_play(sndMut);
	mod_variable_set("mod", "Extra Mutation Options", "extrastacks", mod_variable_get("mod", "Extra Mutation Options", "extrastacks") + 2 * (skill_get(mod_current) - global.stacks));
	mod_variable_set("mod", "LOMuts", "canOutcast", mod_variable_get("mod", "LOMuts", "canOutcast") + 1 * (skill_get(mod_current) - global.stacks));
	global.stacks = skill_get(mod_current);
	
#define skill_lose
	mod_variable_set("mod", "Extra Mutation Options", "extrastacks", mod_variable_get("mod", "Extra Mutation Options", "extrastacks") + 2 * (skill_get(mod_current) - global.stacks));
	mod_variable_set("mod", "LOMuts", "canOutcast", mod_variable_get("mod", "LOMuts", "canOutcast") + 1 * (skill_get(mod_current) - global.stacks));
	global.stacks = skill_get(mod_current);

#define step
	if(GameCont.level >= 10){
		GameCont.skillpoints += skill_get(mod_current);
		skill_set(mod_current, 0);
		audio_sound_set_track_position(sound_play_pitchvol(sndMutant15Cnfm, 2.5, 0.2),0.4);
	}