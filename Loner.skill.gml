#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Loner.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Loner Icon.png", 1, 8, 8)
global.chosen = [];
global.skill = [];

#define skill_name
	return "Loner";
	
#define skill_text
	return `Choose 1 @(color:${make_color_rgb(84, 58, 24)})outcast@s mutation#It has 2x power`;

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "You've got loneliness#to share now";

#define skill_avail
	return true;

#define skill_sacrifice
	return false;

#define game_start
	global.skill = []; //reset the skill tracker thing
	
//code stolen from Prismatic Iris in Defpack
#define skill_take(_num)
	if(_num > 0 && instance_exists(LevCont)){
		 // Sound:
		if(array_length(global.skill) == 0){sound_play(sndMut);}

		 // Increase important GameCont variables to account for a new selection of mutations
		GameCont.skillpoints++;
		GameCont.endpoints++;

		if(fork()){
		    wait(0); // Very miniscule pause so the game can catch up
		    GameCont.endpoints--; // Fix what we did before
		    with(SkillIcon) instance_destroy(); // Obliterate all leftover skill icons
			
			//this is the list of mutations the player has
			var mutList = [];
			
			var _skills = mod_get_names("skill");
			with(_skills){
				if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast") && mod_script_exists("skill", self, "skill_avail") && mod_script_call("skill", self, "skill_avail")){
					array_push(mutList, self);
				}
			}
			
			//this is a list of the mutations we're using
			global.chosen = [];

		    if(crown_current = 8) { // Crown of Destiny stuff
		    	LevCont.maxselect++;
				
				var r = irandom(array_length(mutList) - 1);
				array_push(global.chosen, mutList[r]);
		    	skill_create(mutList[r], instance_number(mutbutton));
		    	if(array_length(instances_matching(Player, "race", "horror")) > 0) {
					var attempts = 0;
					while(attempts < 15){
						var r = irandom(array_length(mutList) - 1);
						var test = true;
						for(var i = 0; i < array_length(global.chosen); i++){
							if(mutList[r] == global.chosen[i]){
								test = false;
								break;
							}
						}
						if(test){
							array_push(global.chosen, mutList[r]);
							skill_create(mutList[r], instance_number(mutbutton));
							break;
						}
						attempts++;
					}
		    	}
		    }

		    else {
	            var s = mod_variable_get("mod", "Extra Mutation Options", "target");

				LevCont.maxselect = s - 1;

	             // Add skills until full
	            for(var f = 0; f < s; f++) {
					var attempts = 0;
					while(attempts < 15){
						var r = irandom(array_length(mutList) - 1);
						var test = true;
						for(var i = 0; i < array_length(global.chosen); i++){
							if(mutList[r] == global.chosen[i]){
								test = false;
								break;
							}
						}
						if(test){
							array_push(global.chosen, mutList[r]);
							skill_create(mutList[r], instance_number(mutbutton));
							break;
						}
						attempts++;
					}
					if(attempts == 15){
						skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
					}
	            }

	             // For uneven amount of muts
	            var n = instance_number(mutbutton)/2;
	            if(n != round(n)) with(SkillIcon) num += 0.5;
		    }
			//figure out which one the player picked
			var chosen = -1;
			while(instance_exists(SkillIcon) && chosen == -1){
				wait(0);
				with(SkillIcon){
					for(var i = 0; i < maxp; i++){
						if(num == 1 && button_pressed(i, "key1")){chosen = skill;}
						if(num == 2 && button_pressed(i, "key2")){chosen = skill;}
						if(num == 3 && button_pressed(i, "key3")){chosen = skill;}
						if(num == 4 && button_pressed(i, "key4")){chosen = skill;}
						if(num == 5 && button_pressed(i, "key5")){chosen = skill;}
						if(num == 6 && button_pressed(i, "key6")){chosen = skill;}
						if(num == 7 && button_pressed(i, "key7")){chosen = skill;}
						if(num == 8 && button_pressed(i, "key8")){chosen = skill;}
						if(num == 9 && button_pressed(i, "key9")){chosen = skill;}
						if(addy == 0 && button_pressed(i, "fire")){chosen = skill;}
					}
				}
				if(chosen != -1){
					array_push(global.skill, chosen);
					wait(0);
					skill_set(chosen, 2);
					if(array_length(global.skill) < skill_get(mod_current)){
						skill_take(1);
					}
				}
			}
		    exit;
		}
	}
	else {
		//this is the list of mutations the player has
		var mutList = [];
		
		var _skills = mod_get_names("skill");
		with(_skills){
			if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast") && mod_script_exists("skill", self, "skill_avail") && mod_script_call("skill", self, "skill_avail")){
				array_push(mutList, self);
			}
		}
		
		if(array_length(mutList) > 0){
			var r = irandom(array_length(mutList) - 1);
			array_push(global.skill, mutList[r]);
			skill_set(mutList[r], 2);
		}
	}

#define skill_lose
	while(array_length(global.skill) > skill_get(mod_current)){
		var r = irandom(array_length(global.skill) - 1);
		skill_set(global.skill[r], max(skill_get(global.skill[r])-2, 0));
		var _new = array_slice(global.skill, 0, r);
		array_copy(_new, array_length(_new), global.skill, r + 1, array_length(global.skill) - (r + 1));
		global.skill = _new;
	}

#define skill_create(_skill, _num)
	with(instance_create(0, 0, SkillIcon)) {
		creator = LevCont;
		num     = _num;
		alarm0  = num + 3;
		skill   = _skill;
		
		//Make sure Extra Mutation Options doesn't add stuff when it's not needed
		extramuts = 1;

		if(is_string(_skill) && mod_exists("skill", _skill)){
			 // Apply relevant scripts
			mod_script_call("skill", _skill, "skill_button");
			name = mod_script_call("skill", _skill, "skill_name");
			text = mod_script_call("skill", _skill, "skill_text");
		}else if(is_real(_skill)){
			sprite_index = sprSkillIcon;
			image_index = _skill;
			name = skill_get_name(_skill);
			text = skill_get_text(_skill);
		}
	}