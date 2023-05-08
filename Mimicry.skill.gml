#define init
//safeMimicry forces only ultras that are (probably) compatible to show up. Turn this off for extra spice! (..most of the mutations probably won't work, though)
global.safeMimicry = 1;

global.sprSkillIcon = sprite_add("Sprites/Main/Mimicry.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Mimicry Icon.png", 1, 8, 8)
global.activations = 0;
global.newLevel = true;
global.takenUltras = [];
global.implementedUltras = [[char_fish, 1], [char_fish, 2], [char_crystal, 1], [char_eyes, 1], [char_eyes, 2], [char_melting, 1], [char_venuz, 1], [char_venuz, 2], [char_rebel, 1], [char_rebel, 2]];
global.tempEndpoints = GameCont.endpoints;
global.tempSkillpoints = GameCont.skillpoints;
global.canActivate = 1;

//This is for other mods to call for mimicry compat
#define ultra_get(_race, _name)
	with(global.takenUltras){
		if(self[0] != string_lower(_race)){
			continue;
		}
		if(self[1] == string_lower(_name)){
			return true;
		}
	}
	return false;

#define skill_name
	return "Mimicry";
	
#define skill_text
	var text = "At @gULTRA@s, also choose#@wANOTHER@s mutant's ultra";
	//text += "#lose the last mutation you took";
	with(global.takenUltras){
		var desc = ultra_remake_get_desc(self[0], self[1]);
		text += "#@w" + desc[0] + ":@s#" + desc[1];
	}
	return text;

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_avail
	return !is_undefined(skill_get_at(0));
	
#define skill_sacrifice return false; //metamorphosis compat thing
	
#define skill_wepspec
	return 0;

#define skill_tip
	return choose("Don't listen to the mutation#@q@wBE WHO YOU ARE", "Time for wacky");
	
#define skill_type
	return "utility";
	
#define skill_take
	sound_play(sndMutant1Wrld);
	sound_play(sndMutant2Wrld);
	sound_play(sndMutant3Wrld);
	sound_play(sndMutant4Wrld);
	if(global.activations >= skill_get(mod_current)){
		global.activations--;
	}
	/*var i = 0;
	while(!is_undefined(skill_get_at(i))){i++}
	while(is_string(skill_get_at(i)) && 
		(
			(mod_script_exists("skill", skill_get_at(i-2), "skill_sacrifice") && mod_script_call("skill", skill_get_at(i-2), "skill_sacrifice")) ||
			(mod_script_exists("skill", skill_get_at(i-2), "skill_outcast") && mod_script_call("skill", skill_get_at(i-2), "skill_outcast")) ||
			(mod_script_exists("skill", skill_get_at(i-2), "skill_blight") && mod_script_call("skill", skill_get_at(i-2), "skill_blight"))
		))
		{i--}
	if(is_undefined(skill_get_at(i-2))){
		trace("Hey. You don't have any removable mutations.");
		return;
	}
	skill_set(skill_get_at(i-2), 0);*/
	

#define game_start
global.activations = 0;
global.takenUltras = [];
	
#define step
	//REDUCE ENEMY RADS
	/*with(instances_matching_ne(enemy, "mimicry", true)){
		mimicry = true;
		if("raddrop" in self){raddrop = ceil(raddrop/2);}
	}*/
	
	if(instance_exists(GenCont)) global.newLevel = true;
	else if(global.newLevel){
		global.newLevel = false;
		ultra_remake_level_start();
	}
	ultra_remake_step();
	if(instance_exists(LevCont) && array_length(instances_matching([SkillIcon, EGSkillIcon], "mimic", true)) == 0 && global.activations < skill_get(mod_current) && global.canActivate){
		var ultraOnscreen = 0;
		with(SkillIcon){
			if(is_string(skill) && mod_script_exists("skill", skill, "skill_ultra")){
				ultraOnscreen = true;
				break;
			}
		}
		if(instance_exists(EGSkillIcon) || ultraOnscreen){
			global.activations++;
			 // Increase important GameCont variables to account for a new selection of mutations
			global.tempEndpoints = GameCont.endpoints;
			global.tempSkillpoints = GameCont.skillpoints;
			GameCont.endpoints++;
			global.canActivate = 0;

			if(fork()){
				wait(0); // Very miniscule pause so the game can catch up
				global.canActivate = 1;
				with(SkillIcon) instance_destroy(); // Obliterate all leftover skill icons
				with(EGSkillIcon) instance_destroy();
				
				//this is the list of ultras to choose from
				var ultraList = [];
				
				for(var i = char_fish; i <= char_frog; i++){
					var skip = false;
					with(Player){
						if(i == race_id || i == char_bigdog){
							skip = true;
							break;
						}
					}
					if(skip){
						continue;
					}
					for(var i2 = 1; i2 <= ultra_count(i); i2++){
						skip = false;
						with(global.takenUltras){
							if(race_get_id(self[0]) == i && i2 == self[1]){
								skip = true;
								break;
							}
						}
						if(global.safeMimicry && !skip){
							skip = true;
							with(global.implementedUltras){
								if(race_get_id(self[0]) == i && i2 == self[1]){
									skip = false;
									break;
								}
							}
						}
						if(skip){
							continue;
						}
						array_push(ultraList, i*3+i2-4);
					}
				}
				
				//list of modded ultras
				var modskills = mod_get_names("skill");
				for(i = 0; i < array_length_1d(modskills); i++){
					if(mod_exists("skill", modskills[i]) && mod_script_exists("skill", modskills[i], "skill_ultra")){
						if(global.safeMimicry && !(mod_script_exists("skill", modskills[i], "skill_mimicry") && mod_script_call("skill", modskills[i], "skill_mimicry"))){
							continue;
						}
						var ult = mod_script_call("skill", modskills[i], "skill_ultra");
						if(is_string(ult) && (mod_exists("race", ult) || string_count(string_lower(ult), "fish crystal eyes melting plant venuz steroids robot chicken rebel horror rogue skeleton frog")) || is_real(ult) && ult != -1){
							var skip = false;
							with(Player){
								if(ult == race){
									skip = true;
									break;
								}
								with(global.takenUltras){
									if(self[0] != string_lower(other.race)){
										continue;
									}
									if(self[1] == modskills[i]){
										skip = true;
										break;
									}
								}
								if(skip){
									break;
								}
							}
							if(skip){
								continue;
							}
							array_push(ultraList,modskills[i])
						}
					}else if(mod_exists("skill", modskills[i]) && mod_script_exists("skill", modskills[i], "skill_mimicry")){
						var ult = mod_script_call("skill", modskills[i], "skill_mimicry");
						if(is_string(ult) && (mod_exists("race", ult) || string_count(string_lower(ult), "fish crystal eyes melting plant venuz steroids robot chicken rebel horror rogue skeleton frog")) || is_real(ult) && ult != -1){
							var skip = false;
							with(Player){
								if(ult == race){
									skip = true;
									break;
								}
								with(global.takenUltras){
									if(self[0] != string_lower(other.race)){
										continue;
									}
									if(self[1] == modskills[i]){
										skip = true;
										break;
									}
								}
								if(skip){
									break;
								}
							}
							if(skip){
								continue;
							}
							array_push(ultraList,modskills[i])
						}
					}
				}
				
				//modded races that work with mimicry
				/*var modraces = mod_get_names("race");
				for(i = 0; i < array_length_1d(modraces); i++){
					if(mod_exists("race", modraces[i]) && mod_script_exists("race", modraces[i], "skill_mimicry")){
						var ult = mod_script_call("skill", modskills[i], "skill_ultra");
						if(is_string(ult) && (mod_exists("race", ult) || string_count(string_lower(ult), "fish crystal eyes melting plant venuz steroids robot chicken rebel horror rogue skeleton frog")) || is_real(ult) && ult != -1){
							var skip = false;
							with(Player){
								if(ult == race){
									skip = true;
									break;
								}
								with(global.takenUltras){
									if(self[0] != string_lower(other.race)){
										break;
									}
									if(self[1] == modskills[i]){
										skip = true;
										break;
									}
								}
								if(skip){
									break;
								}
							}
							if(skip){
								continue;
							}
							array_push(ultraList,modskills[i])
						}
					}
				}*/
				
				//this is a list of the ultras we're using
				global.chosen = [];
				var s = mod_variable_get("mod", "Extra Mutation Options", "stacks");
				var _horrorNum = 0;
				with(Player){
					if(race == char_horror){_horrorNum++;}
				}
				s = (is_undefined(s) ? 0 : s) + (crown_current == 8 ? 1 : 4) + _horrorNum;
				
				LevCont.maxselect = s - 1;
				
				 // Add skills until full
				for(var f = 0; f < s; f++) {
					var attempts = 0;
					while(attempts < 15){
						var r = seeded_random(GameCont.mutindex*1000+attempts+f*15, 0, array_length(ultraList) - 1, 1);
						var test = true;
						for(var i = 0; i < array_length(global.chosen); i++){
							if(ultraList[r] == global.chosen[i]){
								test = false;
								break;
							}
						}
						if(test){
							array_push(global.chosen, ultraList[r]);
							skill_create(ultraList[r], instance_number(mutbutton));
							break;
						}
						attempts++;
					}
					if(attempts == 15){
						skill_create(ultraList[seeded_random(GameCont.mutindex*1000+attempts+f*15, 0, array_length(ultraList) - 1, 1)], instance_number(mutbutton));
					}
				}

				 // For uneven amount of muts
				var n = instance_number(mutbutton)/2;
				if(n != round(n)) with([SkillIcon,EGSkillIcon]) with(self) num += 0.5;
				
				//figure out which one the player picked
				var chosen = -1;
				var chosenSkill = -1;
				while((instance_exists(SkillIcon) || instance_exists(EGSkillIcon)) && chosen == -1){
					wait(0);
					GameCont.endpoints = global.tempEndpoints;
					GameCont.skillpoints = global.tempSkillpoints;
					with(SkillIcon){
						for(var i = 0; i < maxp; i++){
							if(num == 0 && button_pressed(i, "key1")){chosen = race;chosenSkill = skill;}
							if(num == 1 && button_pressed(i, "key2")){chosen = race;chosenSkill = skill;}
							if(num == 2 && button_pressed(i, "key3")){chosen = race;chosenSkill = skill;}
							if(num == 3 && button_pressed(i, "key4")){chosen = race;chosenSkill = skill;}
							if(num == 4 && button_pressed(i, "key5")){chosen = race;chosenSkill = skill;}
							if(num == 5 && button_pressed(i, "key6")){chosen = race;chosenSkill = skill;}
							if(num == 6 && button_pressed(i, "key7")){chosen = race;chosenSkill = skill;}
							if(num == 7 && button_pressed(i, "key8")){chosen = race;chosenSkill = skill;}
							if(num == 8 && button_pressed(i, "key9")){chosen = race;chosenSkill = skill;}
							if(num == 9 && button_pressed(i, "key0")){chosen = race;chosenSkill = skill;}
							if(addy == 0 && button_pressed(i, "fire")){chosen = race;chosenSkill = skill;}
						}
					}
					if(chosen != -1){
						//player_set_race(3,chosen);
						ultra_remake_take(chosen, chosenSkill);
						GameCont.skillpoints++;
						with(EGSkillIcon){
							instance_destroy();
						}
						break;
					}
					with(EGSkillIcon){
						for(var i = 0; i < maxp; i++){
							if(num == 0 && button_pressed(i, "key1")){chosen = race;chosenSkill = mimicskill;}
							if(num == 1 && button_pressed(i, "key2")){chosen = race;chosenSkill = mimicskill;}
							if(num == 2 && button_pressed(i, "key3")){chosen = race;chosenSkill = mimicskill;}
							if(num == 3 && button_pressed(i, "key4")){chosen = race;chosenSkill = mimicskill;}
							if(num == 4 && button_pressed(i, "key5")){chosen = race;chosenSkill = mimicskill;}
							if(num == 5 && button_pressed(i, "key6")){chosen = race;chosenSkill = mimicskill;}
							if(num == 6 && button_pressed(i, "key7")){chosen = race;chosenSkill = mimicskill;}
							if(num == 7 && button_pressed(i, "key8")){chosen = race;chosenSkill = mimicskill;}
							if(num == 8 && button_pressed(i, "key9")){chosen = race;chosenSkill = mimicskill;}
							if(num == 9 && button_pressed(i, "key0")){chosen = race;chosenSkill = mimicskill;}
							if(addy == 0 && button_pressed(i, "fire")){chosen = race;chosenSkill = mimicskill;}
						}
					}
					if(chosen != -1){
						//player_set_race(max(maxp - global.activations, 1),race_get_id(chosen));
						ultra_remake_take(chosen, chosenSkill);
						GameCont.endpoints++;
						with(SkillIcon){
							instance_destroy();
						}
						break;
					}
				}
				global.tempEndpoints = 0;
				global.tempSkillpoints = 0;
				if(GameCont.mutindex <= 0){
					GameCont.mutindex = 1;
				}
				exit;
			}
		}
	}

#define skill_create(_skill, _num)
	if(is_real(_skill)){
		ultra_create(_skill, _num);
		exit;
	}
	if(is_array(_skill)){
		modded_ultra_create(_skill, _num);
		exit;
	}
	with(instance_create(0, 0, SkillIcon)) {
		creator = LevCont.id;
		num     = _num;
		alarm0  = num + 3;
		skill   = _skill;
		mimic   = true;

		if(is_string(_skill) && mod_exists("skill", _skill)){
			 // Apply relevant scripts
			mod_script_call("skill", _skill, "skill_button");
			name = mod_script_call("skill", _skill, "skill_name");
			text = mod_script_call("skill", _skill, "skill_text");
			race = mod_script_call("skill", _skill, "skill_ultra");
		}
	}

#define modded_ultra_create(_skill, _num)
	if(is_real(_skill)){
		ultra_create(_skill, _num);
		exit;
	}
	if(is_string(_skill)){
		skill_create(_skill, _num);
		exit;
	}
	with(instance_create(0, 0, SkillIcon)) {
		creator = LevCont.id;
		num     = _num;
		alarm0  = num + 3;
		skill   = _skill[0] + " " + string(_skill[1]);
		mimic   = true;

		if(is_string(_skill[0]) && mod_exists("race", _skill[0])){
			 // Apply relevant scripts
			mod_script_call("race", _skill[0], "skill_button");
			name = mod_script_call("race", _skill[0], "skill_name");
			text = mod_script_call("race", _skill[0], "skill_text");
			race = mod_script_call("race", _skill[0], "skill_ultra");
		}
	}

#define ultra_create(_skill, _num)
	if(is_string(_skill)){
		skill_create(_skill, _num);
		exit;
	}
	if(is_array(_skill)){
		modded_ultra_create(_skill, _num);
		exit;
	}
	with(instance_create(0, 0, EGSkillIcon)) {
		creator = LevCont.id;
		race    = race_get_name(floor(_skill/3)+1);
		num     = _num;
		alarm0  = num + 3;
		skill   = -1;//(_skill % 3) + 1;
		mimicskill = (_skill % 3) + 1;
		mimic   = true;
		
		if(is_real(_skill)){
			sprite_index = sprEGSkillIcon;
			image_index = _skill;
			var desc = ultra_remake_get_desc(race_get_name(floor(_skill/3)+1), (_skill % 3) + 1);
			name = desc[0];
			text = desc[1];
			//name = loc_get("Races:"+string(floor(_skill/3)+1)+":Ultra:"+string(skill)+":Name");
			//text = loc_get("Races:"+string(floor(_skill/3)+1)+":Ultra:"+string(skill)+":Text");
		}
	}

#define ultra_remake_get_desc(_race, _skill)
	if(is_real(_race)){_race = race_get_name(_race);}
	_race = string_lower(_race);
	if(is_string(_skill)){_skill = string_lower(_skill);}
	switch(_race){
		case "fish":
			switch(_skill){
				case 1: return ["CONFISCATE", "@wENEMIES @sSOMETIMES DROP @wCHESTS@s"] break;
				case 2: return ["GUN WARRANT", "@yINFINITE AMMO@s THE FIRST 7 SECONDS#AFTER EXITING A @pPORTAL@s"] break;
			}
			break;
		case "crystal":
			switch(_skill){
				case 1: return ["FORTRESS", "+3 MAX @rHP@s"] break; //OG: +6 MAX @rHP@s
				case 2: return ["JUGGERNAUT", "GAIN A @wSHIELD@s#AFTER BEING HIT" + "#UNFINISHED"] break; //OG: MOVE WHILE @wSHIELDED@s
			}
			break;
		case "eyes":
			switch(_skill){
				case 1: return ["PROJECTILE STYLE", "@wTELEKINESIS@s HOLDS YOUR @wPROJECTILES@s#WHILE FIRING"] break; //OG: @wTELEKINESIS@s HOLDS YOUR @wPROJECTILES@s
				case 2: return ["MONSTER STYLE", "PUSH NEARBY @wENEMIES@s AWAY#WHEN NOT @wFIRING@s"] break; //OG: PUSH NEARBY @wENEMIES@s AWAY#WHEN NOT USING @wTELEKINESIS@s
			}
			break;
		case "melting":
			switch(_skill){
				case 1: return ["BRAIN CAPACITY", "@rLOW HP @wENEMIES@s BLOW UP"] break; //OG: BLOW UP @rLOW HP @wENEMIES@s
				case 2: return ["DETACHMENT", "3 MORE @gMUTATIONS@s#LOSE HALF OF YOUR @rHP@s" + "#NOT CHECKED"] break;
			}
			break;
		case "plant":
			switch(_skill){
				case 1: return ["TRAPPER", "SOME @wENEMIES@s SPAWN @wSNARES@s ON DEATH#BIG @wSNARES@s" + "#UNFINISHED"] break; //OG: BIG @wSNARE@s
				case 2: return ["KILLER", "@wSNARES@s SPAWN AROUND THE LEVEL#@wENEMIES@s KILLED ON @wSNARES@s#SPAWN @wSAPLINGS@s" + "#UNFINISHED"] break; //OG: @wENEMIES@s KILLED ON YOUR @wSNARE@s#SPAWN @wSAPLINGS@s
			}
			break;
		case "venuz":
			switch(_skill){
				case 1: return ["IMA GUN GOD", "HIGHER @wRATE OF FIRE@s"] break;
				case 2: return ["BACK 2 BIZNIZ", "RANDOM FREE @wPOP POP@s"] break; //OG: FREE @wPOP POP@s UPGRADE
			}
			break;
		case "steroids":
			switch(_skill){
				case 1: return ["AMBIDEXTROUS", "DOUBLE @wWEAPONS@s FROM @wCHESTS@s" + "#UNFINISHED"] break;
				case 2: return ["GET LOADED", "@yAMMO CHESTS@s CONTAIN ALL @yAMMO TYPES@s" + "#UNFINISHED"] break;
			}
			break;
		case "robot":
			switch(_skill){
				case 1: return ["REFINED TASTE", "HIGH TIER @wWEAPONS@s ONLY#AUTO EAT @wWEAPONS@s LEFT BEHIND" + "#UNFINISHED"] break;
				case 2: return ["REGURGITATE", "EATING @wWEAPONS@s CAN DROP @wCHESTS@s#AUTO EAT @wWEAPONS@s LEFT BEHIND" + "#UNFINISHED"] break;
			}
			break;
		case "chicken":
			switch(_skill){
				case 1: return ["HARDER TO KILL", "HARD TO KILL#KILLS EXTEND BLEED TIME" + "#UNFINISHED"] break; //OG: KILLS EXTEND BLEED TIME
				case 2: return ["DETERMINATION", "@wFIRE@s WHEN OUT OF @yAMMO@s TO THROW#THROWN @wWEAPONS@s CAN TELEPORT BACK#TO YOUR SECONDARY SLOT" + "#UNFINISHED"] break; //OG: THROWN @wWEAPONS@s CAN TELEPORT BACK#TO YOUR SECONDARY SLOT
			}
			break;
		case "rebel":
			switch(_skill){
				case 1: return ["PERSONAL GUARD", "START A LEVEL WITH#LOOP + 2 @wALLIES@s#ALL @wALLIES@s HAVE MORE @rHP@s"] break; //OG: START A LEVEL WITH 2 @wALLIES@s#ALL @wALLIES@s HAVE MORE @rHP@s
				case 2: return ["RIOT", "START A LEVEL WITH#LOOP X 2 @wALLIES@s"] break; //OG: DOUBLE @wALLY@s SPAWNS
			}
			break;
		case "horror":
			switch(_skill){
				case 1: return ["STALKER", "@wENEMIES@s EXPLODE IN @gRADIATION@s ON DEATH" + "#UNFINISHED"] break;
				case 2: return ["ANOMALY", "@pPORTALS@s APPEAR EARLIER" + "#UNFINISHED"] break;
				case 3: return ["MELTDOWN", "DOUBLE @gRAD@s CAPACITY" + "#UNFINISHED"] break;
			}
			break;
		case "rogue":
			switch(_skill){
				case 1: return ["SUPER PORTAL STRIKE", "TWO @wAUTOMATIC@s#@bPORTAL STRIKES@s PER LEVEL" + "#UNFINISHED"] break; //OG: DOUBLE @bPORTAL STRIKE@s PICKUPS#AND CAPACITY
				case 2: return ["SUPER BLAST ARMOR", "SUPER BLAST ARMOR" + "#UNFINISHED"] break;
			}
			break;
		case "skeleton":
			switch(_skill){
				case 1: return ["REDEMPTION", "BACK IN THE FLESH" + "#UNFINISHED"] break;
				case 2: return ["DAMNATION", "FIRING WHEN EMPTY BLOOD GAMBLES#FAST RELOAD AFTER BLOOD GAMBLE" + "#UNFINISHED"] break; //OG: FAST RELOAD AFTER BLOOD GAMBLE
			}
			break;
		case "frog":
			switch(_skill){
				case 1: return ["DISTANCE", "RADS CAN SPAWN TOXIC GAS" + "#UNFINISHED"] break;
				case 2: return ["INTIMACY", "CONTINUOUSLY SPAWN TOXIC GAS" + "#UNFINISHED"] break;
			}
			break;
	}
	//fallback
	var _id = race_get_id(_race);
	return [loc_get("Races:"+string(_id)+":Ultra:"+string(_skill)+":Name"), loc_get("Races:"+string(_id)+":Ultra:"+string(_skill)+":Text")]

#define ultra_remake_take(_race, _skill)
if(is_real(_race)){_race = race_get_name(_race);}
_race = string_lower(_race);
if(is_string(_skill)){_skill = string_lower(_skill);}
array_push(global.takenUltras, [_race, _skill]);
switch(_race){
	case "crystal":
		switch(_skill){
			//Fortress
			case 1:
				with(Player){maxhealth+=3;my_health+=3;}
				break;
		}
		break;
	case "melting":
		switch(_skill){
			//Detachment
			case 2:
				with Player {
					maxhealth = ceil(maxhealth / 2);
					if(my_health > maxhealth){my_health = maxhealth;lsthealth = maxhealth;}
				}
				GameCont.skillpoints += 3;
				
				if(instance_exists(LevCont)){
					with(LevCont) {instance_destroy();}
					if(!instance_exists(LevCont)){
						instance_create(0,0,LevCont);
						with(GenCont){instance_destroy();}
					}
				}
				break;
		}
		break;
	case "venuz":
		switch(_skill){
			//Ima Gun God
			case 1:
				with(Player){reloadspeed += 0.6;}
				break;
		}
		break;
}

#define ultra_remake_level_start
with(global.takenUltras){
	switch(self[0]){
		case "fish":
			switch(self[1]){
				//Gun Warrant
				case 2:
					with(Player){infammo = 7*30}
					break;
			}
			break;
		case "rebel":
			switch(self[1]){
				//Personal Guard
				case 1:
					with(Player){
						repeat(2 + GameCont.loops){
							with(instance_create(x,y,Ally)){
								creator = other;team = other.team;
								my_health = 30;
								maxhealth = 30;
							}
						}
					}
					break;
				//Riot
				case 2:
					with(Player){
						repeat(2 * GameCont.loops){
							with(instance_create(x,y,Ally)){
								creator = other;team = other.team;
							}
						}
					}
					break;
			}
			break;
	}
	switch(self[1]){
		case "union":
			with(Player){
				if(fork()){
					wait(5){
						repeat(8){
							with(instance_create(x,y,Ally)){
								creator = other;team = other.team;
							}
						}	
					}
				}
			}
			break;
	}
}

#define ultra_remake_step
with(global.takenUltras){
	switch(self[0]){
		case "fish":
			switch(self[1]){
				case 1:
					// Confiscate
					// Thanks Squiddy
					if instance_exists(HPPickup) {
						var _intoHpChests = instances_matching(HPPickup, "mimicry_fish_ultra_a", null);
						
						if array_length(_intoHpChests) {
							with _intoHpChests {
								mimicry_fish_ultra_a = true;
								
								if random(5) < 1
								&& !position_meeting(xstart, ystart, ChestOpen) {
									with instance_create(x, y, HealthChest) {
										mimicry_fish_ultra_a = true;
									}
									
									instance_delete(self);
								}
							}
						}
					}

					if instance_exists(AmmoPickup) {
						var _intoAmmoChests = instances_matching(AmmoPickup, "mimicry_fish_ultra_a", null);
						
						if array_length(_intoAmmoChests) {
							with _intoAmmoChests {
								mimicry_fish_ultra_a = true;
								
								if random(5) < 1
								&& !position_meeting(xstart, ystart, ChestOpen) {
									with instance_create(x, y, AmmoChest) {
										mimicry_fish_ultra_a = true;
									}
									
									instance_delete(self);
								}
							}
						}
					}

					if instance_exists(AmmoPickup) {
						var _intoAmmoChests = instances_matching(WepPickup, "mimicry_fish_ultra_a", null);
						
						if array_length(_intoAmmoChests) {
							with _intoAmmoChests {
								mimicry_fish_ultra_a = true;
								
								if random(5) < 1
								&& roll
								&& !position_meeting(xstart, ystart, ChestOpen) {
									with instance_create(x, y, WeaponChest) {
										mimicry_fish_ultra_a = true;
									}
									
									instance_delete(self);
								}
							}
						}
					}
					break;
			}
			break;
		case "eyes":
			switch(self[1]){
				//Projectile Style
				//Thanks Squiddy
				case 1:
					with(Player){
						if(button_check(index, "fire")) {
							with instances_matching(projectile, "creator", id) {
								x = lerp(x, other.x + lengthdir_x(16, direction), 0.4);
								y = lerp(y, other.y + lengthdir_y(16, direction), 0.4);
							}
						}
					}
					break;
				//Monster Style
				//Thanks Squiddy
				case 2:
					with(Player){
						if(button_check(index, "fire")) {
							var _pushStrength = 1;
							
							with instance_rectangle(
								x - 130,
								y - 130,
								x + 130,
								y + 130,
								instances_matching_ne(
									instances_matching_ne(
										hitme,
										"team",
										team,
										0
									),
									"VAGGYBONDESPLSNOSHOOT",
									true
								)
							) {
								if !instance_is(self, prop)
								&& point_distance(x, y, other.x, other.y) < 130 {
									var _awayFromEyes = point_direction(other.x, other.y, x, y);
									var _x = x + lengthdir_x(_pushStrength, _awayFromEyes);
									var _y = y + lengthdir_y(_pushStrength, _awayFromEyes);
									
									if place_free(_x, y) {
										x = _x;
									}
									
									if place_free(x, _y) {
										y = _y;
									}
								}
							}
						}
					}
					break;
			}
			break;
		case "melting":
			switch(self[1]){
				//Brain Capacity
				//Thanks x10
				case 1:
					with(Player){
						with(instances_matching_gt(instances_matching_le(enemy,"my_health",5),"my_health",0))
						{
							if(point_seen(x,y,other.index))
							{
								//jsnotes - this used to check for scarier face LUL
								
								 // Create 1 Blood Explosion (Or 3 If You Have Thronebutt) On Enemy:
								if skill_get(mut_throne_butt){
									ang = random(360);
									repeat(3){
										instance_create(x+lengthdir_x(24,ang),y+lengthdir_y(24,ang),MeatExplosion);
										ang += 120;
									}
								}
								else instance_create(x,y + random_range(-1,1),MeatExplosion);
								
								 // Play Sounds:
								if(skill_get(mut_throne_butt)) sound_play(sndCorpseExploUpg);
								else sound_play(sndCorpseExplo);
								sound_play(sndExplosion);
								
								 // Kill Enemy:
								my_health = 0;
							}	
						}
					}
			}
			break;
		case "plant":
			switch(self[1]){
				//Trapper
				case 1:
					with(instances_matching_ne(Player, "mimcryplant", current_frame)){
						if button_pressed(index, "spec")
						{
							with(instances_matching(Tangle, "p", p)){
								instance_destroy();
							}
							with(instance_create(x,y,TangleSeed)){
								creator = other;
								p = other.index;
								team = other.team;
								event_perform(ev_collision, Wall);
							}
						}
						mimcryplant = current_frame;
					}
					break;
				//Killer
				case 2:
					with(instances_matching_ne(Player, "mimcryplant", current_frame)){
						if button_pressed(index, "spec")
						{
							with(instances_matching(Tangle, "p", p)){
								instance_destroy();
							}
							with(instance_create(x,y,TangleSeed)){
								creator = other;
								p = other.index;
								team = other.team;
								event_perform(ev_collision, Wall);
							}
						}
						mimcryplant = current_frame;
					}
					break;
			}
			break;
		case "venuz":
			switch(self[1]){
				//Back 2 Bizniz
				case 2:
					script_bind_step(bizniz_step, 1);
					break;
			}
			break;
		case "horror":
			switch(self[1]){
				//Stalker
				case 1:
					with(instances_matching_ge(instances_matching_le(hitme, "my_health", 0), "raddrop", 1)){
						if(floor(raddrop * 0.6)){
							repeat(floor(raddrop * 0.6)){
								with(instance_create(x,y,HorrorBullet)){
									direction = random(360);
									speed = 6;
									image_angle = direction;
									creator = instance_nearest(x,y,Player);
									if(creator != noone){
										team = creator.team;
									}
								}
							}
						}
					}
					break;
			}
			break;
		case "frog":
			switch(self[1]){
				//Intimacy
				case 2:
					if(!instance_exists(GenCont)){
						with(Player){
							if(irandom(4 * current_time_scale - 1) == 0){
								with(instance_create(x,y,ToxicGas)){
									direction = other.direction + 180 + random(40) - 20;
									speed = 1 + random(1);
									image_angle = direction;
									creator = other;
									team = other.team;
								}
							}
						}
					}
					break;
			}
			break;
	}
	switch(self[1]){
		case "generalist":
			with(instances_matching_ne(Player, "mimicryplant", current_frame)){
				if button_pressed(index, "spec")
				{
					with(instances_matching(Tangle, "p", p)){
						instance_destroy();
					}
					with(instance_create(x,y,TangleSeed)){
						creator = other;
						p = other.index;
						team = other.team;
						event_perform(ev_collision, Wall);
					}
				}
				mimcryplant = current_frame;
			}
			break;
	}
}

#define bizniz_step
with(Player){
	with(instances_matching(instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching_ne(projectile,"MimicryBizniz",true), "name", "Bone"), "pg", 1), "object_index", ThrownWep), "object_index", HorrorBullet),"team",team)){
		MimicryBizniz = true;
		if(random(2) < 1 && !("name" in self && is_string(name) && (string_count("vector", string_lower(name)) > 0))){
			with(instance_clone()){
				team = other.team;
				//damage = other.damage / global.modifier;
				if(object_index == BloodSlash){
					creator = -4;
				}
				if(object_index != Laser){
					var acc = 1;
					if("creator" in self && instance_exists(creator) && "accuracy" in creator){
						acc = creator.accuracy;
					}
					var r = random_range(-10 * acc,10 * acc);
					direction += r;
					image_angle += r;
				}else{
					x -= lengthdir_x(image_xscale*2,direction);
					y -= lengthdir_y(image_xscale*2,direction);
					with instance_create(x,y,Laser){
						var acc = 1;
						if("creator" in self && instance_exists(creator) && "accuracy" in creator){
							acc = creator.accuracy;
						}
						alarm0 = 1;
						var r = random_range(-10 * acc,10 * acc);
						direction = other.direction + r;
						image_angle = other.image_angle + r;
						hitid = [sprite_index, "LASER"];
						team = other.team;
						creator = other;
					}
					instance_destroy();
				}
			}
		}
	}
}
instance_destroy();


#define loc_get(_key)
	/*
		Similar to "loc(key, defvalue)", but automatically defaults to the base game's actual value
		
		Ex:
			loc_get("Skills:Name:1") == "RHINO SKIN"
	*/
	
	 // Real:
	var _loc = loc(_key, "");
	if(_loc != "") return _loc;
	
	 // Store Defaults:
	if(!mod_variable_exists("skill", mod_current, "loc_default")){
		mod_variable_set("skill", mod_current, "loc_default", {
			"Races" : [
				{ Name: "RANDOM",   Passive: "???",                           Active: "???",                   TB: "",                                                                                Unlock: "",                         SkinUnlock: "",                                                        Ultra: [null, { Name: "BLOOD BOND",          Text: "HP PICKUPS ARE SHARED"                                           }, { Name: "GUN BOND",          Text: "AMMO PICKUPS ARE SHARED"                                                 }, { Name: "EXTRA LEVEL", Text: "BECAUSE SOMEONE FORGOT#TO DEFINE ULTRA MUTATION(S)" }] },
				{ Name: "FISH",     Passive: "GETS MORE @yAMMO@w",            Active: "CAN @wROLL@s",          TB: "WATER BOOST",                                                                     Unlock: "UNLOCKED FROM THE START",  SkinUnlock: "LOOP WITH EVERY CHARACTER",                               Ultra: [null, { Name: "CONFISCATE",          Text: "@wENEMIES@s SOMETIMES DROP @wCHESTS@s"                           }, { Name: "GUN WARRANT",       Text: "@yINFINITE AMMO@s THE FIRST 7 SECONDS#AFTER EXITING A @pPORTAL@s"        }] },
				{ Name: "CRYSTAL",  Passive: "MORE MAX @rHP@w",               Active: "CAN @wSHIELD@s",        TB: "@wTELEPORTATION@s#SHORTER @wSHIELDING@s",                                         Unlock: "UNLOCKED FROM THE START",  SkinUnlock: "REACH 4-?",                                               Ultra: [null, { Name: "FORTRESS",            Text: "+6 MAX @rHP@s"                                                   }, { Name: "JUGGERNAUT",        Text: "MOVE WHILE @wSHIELDED@s"                                                 }] },
				{ Name: "EYES",     Passive: "SEES IN THE DARK",              Active: "TELEKINESIS",           TB: "STRONGER @wTELEKINESIS@s",                                                        Unlock: "REACH 2-1",                SkinUnlock: "REACH 2-?",                                               Ultra: [null, { Name: "PROJECTILE STYLE",    Text: "@wTELEKINESIS@s HOLDS YOUR @wPROJECTILES@s"                      }, { Name: "MONSTER STYLE",     Text: "PUSH NEARBY @wENEMIES@s AWAY#WHEN NOT USING @wTELEKINESIS@s"             }] },
				{ Name: "MELTING",  Passive: "LESS MAX @rHP@w#MORE @gRADS@w", Active: "EXPLODE @wCORPSES@s",   TB: "BIGGER @wCORPSE EXPLOSIONS@s",                                                    Unlock: "DIE",                      SkinUnlock: "REACH THE NUCLEAR THRONE#NO RHINO SKIN OR STRONG SPIRIT", Ultra: [null, { Name: "BRAIN CAPACITY",      Text: "BLOW UP @rLOW HP @wENEMIES@s"                                    }, { Name: "DETACHMENT",        Text: "3 MORE @gMUTATIONS@s#LOSE HALF OF YOUR @rHP@s"                           }] },
				{ Name: "PLANT",    Passive: "IS FASTER",                     Active: "@wSNARE@s ENEMIES",     TB: "@wSNARE@s FINISHES @wENEMIES@s#UNDER 33% @rHP@s",                                 Unlock: "REACH 3-1",                SkinUnlock: "REACH THE NUCLEAR THRONE#IN UNDER 10 MINUTES",            Ultra: [null, { Name: "TRAPPER",             Text: "BIG @wSNARE@s"                                                   }, { Name: "KILLER",            Text: "@wENEMIES@s KILLED ON YOUR @wSNARE@s#SPAWN @wSAPLINGS@s"                 }] },
				{ Name: "Y.V.",     Passive: "HIGHER @wRATE OF FIRE@s",       Active: "@wPOP POP",             TB: "@wBRRRAP",                                                                        Unlock: "REACH 3-?",                SkinUnlock: "GET A GOLDEN WEAPON#FOR EVERY CHARACTER",                 Ultra: [null, { Name: "IMA GUN GOD",         Text: "HIGHER @wRATE OF FIRE@s"                                         }, { Name: "BACK 2 BIZNIZ",     Text: "FREE @wPOP POP@s UPGRADE"                                                }] },
				{ Name: "STEROIDS", Passive: "INACCURATE#AUTOMATIC WEAPONS",  Active: "DUAL WIELDING",         TB: "FIRING GIVES @yAMMO@s FOR#YOUR OTHER @wWEAPON@s#MORE EFFECTIVE WHEN FIRING BOTH", Unlock: "REACH 6-1",                SkinUnlock: "DEFEAT ???",                                              Ultra: [null, { Name: "AMBIDEXTROUS",        Text: "DOUBLE @wWEAPONS@s FROM @wCHESTS@s"                              }, { Name: "GET LOADED",        Text: "@yAMMO CHESTS@s CONTAIN ALL @yAMMO TYPES@s"                              }] },
				{ Name: "ROBOT",    Passive: "FINDS BETTER TECH",             Active: "CAN EAT @wWEAPONS@s",   TB: "BETTER @wWEAPON@s NUTRITION",                                                     Unlock: "REACH 5-1",                SkinUnlock: "EAT ???",                                                 Ultra: [null, { Name: "REFINED TASTE",       Text: "HIGH TIER @wWEAPONS@s ONLY#AUTO EAT @wWEAPONS@s LEFT BEHIND"     }, { Name: "REGURGITATE",       Text: "EATING @wWEAPONS@s CAN DROP @wCHESTS@s#AUTO EAT @wWEAPONS@s LEFT BEHIND" }] },
				{ Name: "CHICKEN",  Passive: "HARD TO KILL",                  Active: "CAN THROW @wWEAPONS@s", TB: "THROWS PIERCE THROUGH @wENEMIES@s",                                               Unlock: "REACH 5-?",                SkinUnlock: "???",                                                     Ultra: [null, { Name: "HARDER TO KILL",      Text: "KILLS EXTEND BLEED TIME"                                         }, { Name: "DETERMINATION",     Text: "THROWN @wWEAPONS@s CAN TELEPORT BACK#TO YOUR SECONDARY SLOT"             }] },
				{ Name: "REBEL",    Passive: "PORTALS @rHEAL@w",              Active: "CAN SPAWN @wALLIES@s",  TB: "HIGHER @wALLY@s RATE OF FIRE",                                                    Unlock: "??? THE NUCLEAR THRONE",   SkinUnlock: "DEFEAT ???",                                              Ultra: [null, { Name: "PERSONAL GUARD",      Text: "START A LEVEL WITH 2 @wALLIES@s#ALL @wALLIES@s HAVE MORE @rHP@s" }, { Name: "RIOT",              Text: "DOUBLE @wALLY@s SPAWNS"                                                  }] },
				{ Name: "HORROR",   Passive: "EXTRA @gMUTATION@w CHOICE",     Active: "@gRADIATION@w BEAM",    TB: "BEAM CHARGES UP FASTER#PROLONGED BEAM USE @rHEALS@s YOU",                         Unlock: "???",                      SkinUnlock: "DEFEAT ???",                                              Ultra: [null, { Name: "STALKER",             Text: "@wENEMIES@s EXPLODE IN @gRADIATION@s ON DEATH"                   }, { Name: "ANOMALY",           Text: "@pPORTALS@s APPEAR EARLIER"                                              }, { Name: "MELTDOWN", Text: "DOUBLE @gRAD@s CAPACITY" }] },
				{ Name: "ROGUE",    Passive: "BLAST ARMOR, @bHEAT@w",         Active: "@bPORTAL STRIKE@s",     TB: "STRONGER @bPORTAL STRIKE@s",                                                      Unlock: "REACH THE NUCLEAR THRONE", SkinUnlock: "DEFEAT ???",                                              Ultra: [null, { Name: "SUPER PORTAL STRIKE", Text: "DOUBLE @bPORTAL STRIKE@s PICKUPS#AND CAPACITY"                   }, { Name: "SUPER BLAST ARMOR", Text: "SUPER BLAST ARMOR"                                                       }] },
				{ Name: "BIG DOG",  Passive: "MORE @rHP@w#SPIN ATTACK",       Active: "MISSILES",              TB: "FASTER MISSILES AND BULLETS",                                                     Unlock: "DEFEAT BIG DOG",           SkinUnlock: "NO B SKIN YET",                                           Ultra: [null, { Name: "ULTRA SPIN",          Text: "IMPROVED SPIN ATTACK"                                            }, { Name: "ULTRA MISSILES",    Text: "MISSILES FIRE BULLETS"                                                   }] },
				{ Name: "SKELETON", Passive: "LESS HP, SPEED, AND ACCURACY",  Active: "BLOOD GAMBLE",          TB: "BETTER ODDS",                                                                     Unlock: "BECOME ???",               SkinUnlock: "FIRE ???",                                                Ultra: [null, { Name: "REDEMPTION",          Text: "BACK IN THE FLESH"                                               }, { Name: "DAMNATION",         Text: "FAST RELOAD AFTER BLOOD GAMBLE"                                          }] },
				{ Name: "FROG",     Passive: "CAN'T STAND STILL",             Active: "@gTOXIC@w CLOUD",       TB: "TOXIC GAS SPREADS FASTER",                                                        Unlock: "???",                      SkinUnlock: "",                                                        Ultra: [null, { Name: "DISTANCE",            Text: "RADS CAN SPAWN TOXIC GAS"                                        }, { Name: "INTIMACY",          Text: "CONTINUOUSLY SPAWN TOXIC GAS"                                            }] },
				{ Name: "CUZ",      Passive: "LIL BUDDY",                     Active: "GOT UR BACK",           TB: "GO 4 IT",                                                                         Unlock: "???",                      SkinUnlock: "",                                                        Ultra: [null, { Name: "GAME GOD",            Text: "PLAY HARD"                                                       }, { Name: "CAR GOD",           Text: "FAST LYFE"                                                               }] }
			]
		});
	}
	
	 // Search for Default:
	var _loc = global.loc_default;
	with(string_split(_key, ":")){
		 // LWO:
		if(is_object(_loc)){
			_loc = lq_get(_loc, self);
			continue;
		}
		
		 // Array:
		if(is_array(_loc) && string_digits(self) == self){
			var _index = real(self);
			if(_index >= 0 && _index < array_length(_loc)){
				_loc = _loc[_index];
				continue;
			}
		}
		
		 // Failure:
		return "";
	}
	if(is_object(_loc)) _loc = lq_get(_loc, "");
	
	return (is_string(_loc) ? _loc : "");

#define seeded_random(_seed, _min, _max, _irandom)
//Returns a random value from min to max, seeded to the given seed without affecting the overall random seed (if _irandom is true uses irandom)
var _lastSeed = random_get_seed();
random_set_seed(GameCont.baseseed + _seed);
random_set_seed(ceil(random(100000) * random(100000)));
var rand;
if(_irandom){
	rand = _min+irandom(_max-_min);
}else{
	rand = _min+random(_max-_min);
}
random_set_seed(_lastSeed);
return rand;

#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
/*
Returns all instances of `_obj` with their `x` and `y` inside the defined rectangle.
*/
return instances_matching_le(
	instances_matching_le(
		instances_matching_ge(
			instances_matching_ge(
				_obj,
				"x",
				_x1
			),
			"y",
			_y1
		),
		"x",
		_x2
	),
	"y",
	_y2
);

#define instance_clone()
	/*
		Duplicates an instance like 'instance_copy(false)' and clones all of their data structures
	*/
	
	with(instance_copy(false)){
		with(variable_instance_get_names(self)){
			var	_value = variable_instance_get(other, self),
				_clone = data_clone(_value);
				
			if(_value != _clone){
				variable_instance_set(other, self, _clone);
			}
		}
		
		return id;
	}

#define data_clone(_value)
	/*
		Returns an exact copy of the given value
	*/
	
	if(is_array(_value)){
		return array_clone(_value);
	}
	if(is_object(_value)){
		return lq_clone(_value);
	}
	if(ds_list_valid(_value)){
		return ds_list_clone(_value);
	}
	if(ds_map_valid(_value)){
		return ds_map_clone(_value);
	}
	if(ds_grid_valid(_value)){
		return ds_grid_clone(_value);
	}
	if(surface_exists(_value)){
		return surface_clone(_value);
	}
	
	return _value;

#define ds_list_clone(_list)
	/*
		Returns an exact copy of the given ds_list
	*/
	
	var _new = ds_list_create();
	
	ds_list_add_array(_new, ds_list_to_array(_list));
	
	return _new;
	
#define ds_map_clone(_map)
	/*
		Returns an exact copy of the given ds_map
	*/
	
	var _new = ds_map_create();
	
	with(ds_map_keys(_map)){
		_new[? self] = _map[? self];
	}
	
	return _new;
	
#define ds_grid_clone(_grid)
	/*
		Returns an exact copy of the given ds_grid
	*/
	
	var	_w = ds_grid_width(_grid),
		_h = ds_grid_height(_grid),
		_new = ds_grid_create(_w, _h);
		
	for(var _x = 0; _x < _w; _x++){
		for(var _y = 0; _y < _h; _y++){
			_new[# _x, _y] = _grid[# _x, _y];
		}
	}
	
	return _new;
	
#define surface_clone(_surf)
	/*
		Returns an exact copy of the given surface
	*/
	
	var _new = surface_create(surface_get_width(_surf), surface_get_height(_surf));
	
	surface_set_target(_new);
	draw_clear_alpha(0, 0);
	draw_surface(_surf, 0, 0);
	surface_reset_target();
	
	return _new;
	