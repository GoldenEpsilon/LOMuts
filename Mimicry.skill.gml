#define init
//safeMimicry forces only ultras that are (probably) compatible to show up. Turn this off for extra spice! (..most of the mutations probably won't work, though)
global.safeMimicry = 1;

global.sprSkillIcon = sprite_add("Sprites/Main/Mimicry.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Mimicry Icon.png", 1, 8, 8)
global.activations = 0;
global.newLevel = true;
global.takenUltras = [];
global.uselessUltras = [[char_rogue, 2], [char_rogue, 1], [char_chicken, 1], [char_skeleton, 2], [char_crystal, 2], [char_chicken, 2]];
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
	return "At @gULTRA@s, also choose#@wANOTHER@s mutant's ultra#lose the last mutation you took";

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
	var i = 0;
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
	skill_set(skill_get_at(i-2), 0);
	

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
						if(global.safeMimicry){
							with(global.uselessUltras){
								if(race_get_id(self[0]) == i && i2 == self[1]){
									skip = true;
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
						player_set_race(3,chosen);
						ultra_remake_take(chosen, chosenSkill);
						GameCont.skillpoints++;
						with(EGSkillIcon){
							instance_destroy();
						}
						break;
					}
					with(EGSkillIcon){
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
						player_set_race(max(maxp - global.activations, 1),race_get_id(chosen));
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
		skill   = (_skill % 3) + 1;
		mimic   = true;
		
		if(is_real(_skill)){
			sprite_index = sprEGSkillIcon;
			image_index = _skill;
			name = loc_get("Races:"+string(floor(_skill/3)+1)+":Ultra:"+string(skill)+":Name");
			text = loc_get("Races:"+string(floor(_skill/3)+1)+":Ultra:"+string(skill)+":Text");
		}
	}

#define ultra_remake_take(_race, _skill)
if(is_real(_race)){_race = loc_get("Races:"+_race+":Name");trace(_race);}
_race = string_lower(_race);
if(is_string(_skill)){_skill = string_lower(_skill);}
array_push(global.takenUltras, [_race, _skill]);
switch(_race){
	case "crystal":
		switch(_skill){
			//Fortress
			case 1:
				with(Player){maxhealth+=6;my_health+=6;}
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
					with(Player){infammo += 7*30}
					break;
			}
			break;
		case "rebel":
			switch(self[1]){
				//Personal Guard
				case 1:
					with(Player){
						repeat(2){
							with(instance_create(x,y,Ally)){
								creator = other;team = other.team;
							}
						}
					}
					break;
				//Riot
				case 2:
					with(Player){
						repeat(2 + 2 * GameCont.loops){
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
		case "eyes":
			switch(self[1]){
				//Projectile Style
				//Thanks x10
				case 1:
					with(Player){
						with instances_matching(instances_matching(projectile, "eyesmimicry", null),"creator",id)
						{
							eyesmimicry = 1;
							if(fork()){
								repeat(30){
									if(instance_exists(self) && instance_exists(creator)){
										x = creator.x + hspeed
										y = creator.y + vspeed
										speed += friction
									}
									wait(1);
								}
								exit;
							}
						}
					}
				//Monster Style
				//Thanks x10
				case 2:
					with(Player){
						if !button_check(index, "spec")
						{
							with(enemy)
							{
								var _push = 1;
								var _dir = point_direction(other.x, other.y, x, y);
								x += lengthdir_x(_push, _dir);
								y += lengthdir_y(_push, _dir);
							}
						}
					}
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