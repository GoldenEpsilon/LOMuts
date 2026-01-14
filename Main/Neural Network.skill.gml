#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Neural Network.png", 1, 12, 16);
	global.sprSkillHUD   = sprite_add("../Sprites/Icons/Neural Network Icon.png", 1, 8, 8);
	global.num = 0;

#define skill_wepspec
	return 1;

#define skill_name
	return "NEURAL NETWORK";

#define skill_text
	return "@wTRAIN@s YOUR @gENERGY@s WEAPONS";

#define skill_button
	sprite_index = global.sprSkillIcon;

#define skill_icon
	return global.sprSkillHUD;
	
#define skill_sacrifice return false; //metamorphosis compat thing

#define skill_tip
	global.num += random(2000) + 500
	return "GENERATION " + string(global.num);
	
#define skill_type
	return "offensive";

#define skill_avail
	var s = mod_get_names("skill"); // Store all skills

	 // Find all skills that have something to do with this
	for(var f = 0; f < array_length(s); f++) {
		 // Checks for if a modded skill happens to have a script for being an neural mutation,
		if(mod_exists("skill", s[f]) and
		   mod_script_exists("skill", s[f], "skill_neural") and
		   skill_get(s[f])){
			return false;
		}
	}
	return true;

//thanks defpack
#define skill_take(_num)
	if(_num > 0 && instance_exists(LevCont)){

		 // Increase important GameCont variables to account for a new selection of mutations
		GameCont.skillpoints++;
		GameCont.endpoints++;
		LevCont.maxselect = 0;

		if(fork()){
		    wait(0); // Very miniscule pause so the game can catch up
		    GameCont.endpoints--; // Fix what we did before
		    with(SkillIcon) instance_destroy(); // Obliterate all leftover skill icons

		    if(crown_current = 8) { // Crown of Destiny stuff
		    	LevCont.maxselect++;

	            var s = mod_get_names("skill"); // Store all skills
				var neural = [];

	             // Find all skills that have something to do with this
	            for(var f = 0; f < array_length(s); f++) {
	            	 // Checks for if a modded skill happens to have a script for being an neural mutation,
	            	if(mod_exists("skill", s[f]) and
	            	   mod_script_exists("skill", s[f], "skill_neural")){
						var _n = mod_script_call("skill", s[f], "skill_neural");
					    if(_n == true ||
						   (is_array(_n) && mod_exists(_n[0], _n[1]))||
						   (is_string(_n) && mod_exists("mod", _n))) {
							array_push(neural, s[f])
						}
					}
	            }
				var r = irandom(array_length(neural)-1);
				skill_create(neural[r], instance_number(mutbutton) + 2);
				
		    	if(array_length(instances_matching(Player, "race", "horror")) > 0 && array_length(neural) > 1) {
					var r2 = irandom(array_length(neural)-1);
					while(r2 == r) {
						r2 = irandom(array_length(neural)-1);
					}
					skill_create(neural[r2], instance_number(mutbutton) + 2);
		    	}
		    }

		    else {
		    	if(array_length(instances_matching(Player, "race", "horror")) > 0) {
					LevCont.maxselect--;
				}
	            var s = mod_get_names("skill"); // Store all skills

	             // Find all skills that have something to do with this
	            for(var f = 0; f < array_length(s); f++) {
	            	 // Checks for if a modded skill happens to have a script for being an neural mutation,
	            	if(mod_exists("skill", s[f]) and
	            	   mod_script_exists("skill", s[f], "skill_neural")){
						var _n = mod_script_call("skill", s[f], "skill_neural");
					    if(_n == true ||
						   (is_array(_n) && mod_exists(_n[0], _n[1]))||
						   (is_string(_n) && mod_exists("mod", _n))) {
							LevCont.maxselect++;
							skill_create(s[f], instance_number(mutbutton) + 2);
						}
					}
	            }

	             // For uneven amount of muts
	            var n = instance_number(mutbutton)/2;
	            if(n != round(n)) with(SkillIcon) num += 0.5;
		    }

		    exit;
		}
	}

#define step

#define skill_create(_skill, _num)
	with(instance_create(0, 0, SkillIcon)) {
		creator = LevCont;
		num     = _num;
		alarm0  = num + 3;
		skill   = _skill;

		foldermut = true;

		 // Apply relevant scripts
        mod_script_call("skill", _skill, "skill_button");
        name = mod_script_call("skill", _skill, "skill_name");
        text = mod_script_call("skill", _skill, "skill_text");
	}
