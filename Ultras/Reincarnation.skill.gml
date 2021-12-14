#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "REINCARNATION";
#define skill_text    return "BECOME#@wSOMEONE ELSE@s";
#define skill_tip     return "The cycle continues";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_mimicry return true;
#define skill_take    
	if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
	skill_reset();
	GameCont.endpoints++;
	with(Player){
		var _selected = char_bigdog;
		while(_selected == char_bigdog || _selected == char_skeleton || _selected == char_melting){
			_selected = irandom(15 + array_length_1d(mod_get_names("race")));
		}
		scrPlayerRacify((_selected < 16) ? race_get_name(_selected) : mod_get_names("race")[_selected - 17]);
	}
	
#define skill_ultra   return "skeleton";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
	
//taken from Metamorphosis (tweaked a bit tho)
#define skill_reset
	/*
		Rerolls all non-special mutations, plus adds a given number of mutation points
	*/
	
	 // Clear All Mutations:
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| !mod_script_exists("skill", _skill, "skill_name")
				|| mod_script_call("skill", _skill, "skill_name") != "REINCARNATION"
			){
				skill_set(_skill, false);
				GameCont.skillpoints++;
				i--;
			}
		}
	}
	// Clear All Ultras:
	for(var i = char_fish; i <= char_frog; i++){
		for(var i2 = 1; i2 <= ultra_count(i); i2++){
			ultra_set(i, i2, 0);
		}
	}
	GameCont.mutindex = 0;
	
//taken from Cheats mod
#define scrPlayerRacify(_race)
	 // Recapitate Self:
	if(race = "chicken" && my_health <= 0){
		sound_stop(sndChickenHeadlessLoop);
		sound_play(sndChickenRegenHead);
		bleed = 0;
		with(chickencorpse) instance_destroy();
	}

	race = _race;
	player_set_race(index, _race);
	player_set_race_pick(index, _race);
	bskin = player_get_skin(index);
	player_set_skin(index, player_get_skin(index));

	 // Set Some Race Specific Stuff:
	canpick = 1;
	canswap = 1;
	notoxic = 0;
	typ_ammo[1] = 32;
	typ_ammo[2] = 8;
	typ_ammo[3] = 7;
	typ_ammo[4] = 6;
	typ_ammo[5] = 10;
	switch(race_get_name(race_id)){
		case "fish":
			for(var i = 1; i <= 5; i++){
				typ_ammo[i] += (i = 1) ? 8 : (i = 5) ? 3 : 2;
			}
			break;

		case "bigdog":
			canpick = 0;
			canswap = 0;
			break;

		case "frog":
			notoxic = 1;
			break;
	}

	my_health = maxhealth;
	lsthealth = my_health;