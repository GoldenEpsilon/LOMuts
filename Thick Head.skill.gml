#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Thick Head.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Thick Head Icon.png", 1, 8, 8)
global.sprSkillHUDMini = sprite_add("Sprites/Thick Head Icon Mini.png", 1, 4, 4)
global.surfIcon = -4;
global.chosen = [];
global.skill = [];

#define skill_name
	return "Thick Head";
	
#define skill_text
	return "Get one of your mutations#@wAGAIN@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	if(global.surfIcon == -4 || array_length(global.skill) == 0){
		return global.sprSkillHUD;
	}
	return global.surfIcon;
	
#define skill_sacrifice return false; //metamorphosis compat thing

#define skill_tip
	return choose("Durr hurr more#mutation more gooder", "Not everything works");
	
#define skill_type
	return "utility";

#define skill_avail
	return skill_get_at(4) != null;

#define skill_temp
	return 1;

#define game_start
	global.skill = []; //reset the skill tracker thing
	
//code stolen from Prismatic Iris in Defpack
#define skill_take(_num)
	if(_num > 0 && instance_exists(LevCont)){
		 // Sound:
		sound_play(sndMutHammerhead);

		 // Increase important GameCont variables to account for a new selection of mutations
		GameCont.skillpoints++;
		GameCont.endpoints++;

		if(fork()){
		    wait(0); // Very miniscule pause so the game can catch up
		    GameCont.endpoints--; // Fix what we did before
		    with(SkillIcon) instance_destroy(); // Obliterate all leftover skill icons
			
			//this is the list of mutations the player has
			var mutList = [];
			
			//going down the list of mutations the player has in the UI
			var mutNum = 0;
			while(skill_get_at(mutNum + 1) != null){ //add 1 to make sure you don't boost Thick Head
				//check to make sure it's not a modded ultra
				if(is_real(skill_get_at(mutNum)) || (is_string(skill_get_at(mutNum)) && mod_exists("skill", skill_get_at(mutNum)) && 
				!mod_script_exists("skill", skill_get_at(mutNum), "skill_ultra") &&
				!(mod_script_exists("skill", skill_get_at(mutNum), "skill_unstackable") && mod_script_call("skill", skill_get_at(mutNum), "skill_unstackable")))){
					array_push(mutList, skill_get_at(mutNum));
				}
				mutNum++;
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
					var amnt = skill_get(chosen);
					wait(0);
					array_push(global.skill, chosen);
					skill_set(chosen, amnt+1);
					make_surf(chosen);
				}
			}
		    exit;
		}
	}

	else {
		//this is the list of mutations the player has
		var mutList = [];
		
		//going down the list of mutations the player has in the UI
		var mutNum = 0;
		while(skill_get_at(mutNum + 1) != null){ //add 1 to make sure you don't boost Thick Head
			//check to make sure it's not a modded ultra
			if(is_real(skill_get_at(mutNum)) || (is_string(skill_get_at(mutNum)) && mod_exists("skill", skill_get_at(mutNum)) && !mod_script_exists("skill", skill_get_at(mutNum), "skill_ultra"))){
				array_push(mutList, skill_get_at(mutNum));
			}
			mutNum++;
		}
		
		if(array_length(mutList) > 0){
			//add 1 to one of your current mutations
			var r = irandom(array_length(mutList) - 1);
			array_push(global.skill, mutList[r]);
			skill_set(mutList[r], skill_get(mutList[r])+1);
			make_surf(mutList[r]);
		}
	}

#define skill_lose
	while(array_length(global.skill) > skill_get(mod_current)){
		var r = irandom(array_length(global.skill) - 1);
		skill_set(global.skill[r], max(skill_get(global.skill[r])-1, 0));
		var _new = array_slice(global.skill, 0, r);
		array_copy(_new, array_length(_new), global.skill, r + 1, array_length(global.skill) - (r + 1));
		global.skill = _new;
	}
	if(array_length(global.skill) > 0){
		r = irandom(array_length(global.skill) - 1);
		make_surf(global.skill[r]);
	}

#define make_surf(_skill)
var surf = surface_create(16,20);
surface_set_target(surf);
draw_clear_alpha(c_white, 0);
if(is_real(_skill)){
	draw_sprite(sprSkillIconHUD, _skill, 8, 8);
}else if(is_string(_skill) && mod_exists("skill", _skill)){
	draw_sprite(mod_script_call("skill", _skill, "skill_icon"), 0, 8, 8);
}
draw_sprite(global.sprSkillHUDMini, 0, 10, 4);
surface_reset_target();
surface_save(surf, "surfIcon.png");
surface_destroy(surf);
global.surfIcon = sprite_add("surfIcon.png", 1, 8, 8);

#define skill_create(_skill, _num)
	with(instance_create(0, 0, SkillIcon)) {
		creator = LevCont;
		num     = _num;
		alarm0  = num + 3;
		skill   = _skill;

		if(is_string(_skill) && mod_exists("skill", _skill)){
			 // Apply relevant scripts
			mod_script_call("skill", _skill, "skill_button");
			name = mod_script_call("skill", _skill, "skill_name");
			if(mod_script_exists("skill", _skill, "stack_text")){
				text = mod_script_call("skill", _skill, "stack_text");
			}else{
				text = mod_script_call("skill", _skill, "skill_text");
			}
		}else if(is_real(_skill)){
			sprite_index = sprSkillIcon;
			image_index = _skill;
			name = skill_get_name(_skill);
			text = skill_get_text(_skill);
		}
	}