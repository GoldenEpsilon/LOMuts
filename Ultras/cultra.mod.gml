/// By Yokin
/// https://yokin.itch.io/custom-ultras

#define init
	global.bind_step = noone;
	
#define cleanup
	 // Delete Script Bindings:
	with(global.bind_step){
		instance_destroy();
	}
	
#define step
	 // Bind Events:
	if(!instance_exists(global.bind_step)){
		global.bind_step = script_bind_step(post_step, 0);
		with(global.bind_step){
			persistent = true;
		}
	}
	
	 // Mutation Point Fix:
	if(instance_exists(SkillIcon)){
		var _inst = instances_matching_le(instances_matching(SkillIcon, "custom_ultra", true), "noinput", 1);
		if(array_length(_inst)){
			var _take = false;
			with(_inst){
				for(var i = 0; i < maxp; i++){
					if(player_is_active(i)){
						var	_mx = mouse_x_nonsync,
							_my = mouse_y_nonsync;
							
						 // No Co-op Desync (Mouse is 1 frame behind in co-op, don't click too fast bro):
						for(var j = 0; j < maxp; j++){
							if(player_is_active(j) && player_get_uid(j) != player_get_uid(i)){
								_mx = mouse_x[i];
								_my = mouse_y[i];
								break;
							}
						}
						
						 // Give Mutation Point When Selected:
						if(
							button_pressed(i, `key${num + 1}`)
							|| (button_pressed(i, "fire") && position_meeting(_mx, _my, self))
							|| (button_pressed(i, "okay") && "select" in creator && creator.select == num)
						){
							_take = true;
							break;
						}
					}
				}
				if(_take){
					break;
				}
			}
			if(_take){
				GameCont.skillpoints++;
				GameCont.mutindex--;
			}
		}
	}
	
#define post_step
	 // Delete Untaken Mutation Buttons:
	if(instance_exists(mutbutton)){
		var _inst = instances_matching_ne(mutbutton, "creator", noone);
		if(array_length(_inst)){
			with(_inst){
				if(!instance_exists(creator)){
					with(LevCont){
						maxselect--;
					}
					instance_destroy();
				}
			}
		}
	}
	
	 // Spawning Custom Ultra Icons:
	if(instance_exists(LevCont)){
		var _inst = instances_matching(LevCont, "custom_ultra", null);
		if(array_length(_inst)){
			with(_inst){
				custom_ultra = (
					GameCont.endpoints > 0
					&& GameCont.crownpoints <= 0
					&& GameCont.skillpoints <= 0
				);
				if(custom_ultra){
					var	_ultraPlayer   = 0,
						_ultraGive     = [],
						_raceCUltraMap = ds_map_create();
						
					 // Compile Custom Ultra Map:
					var _skillMods = mod_get_names("skill");
					for(var i = 0; i < array_length(_skillMods); i++){
						var _skill = _skillMods[i];
						if(mod_script_exists("skill", _skill, "skill_ultra")){
							var _skillRace = race_get_name(mod_script_call("skill", _skill, "skill_ultra"));
							if(!ds_map_exists(_raceCUltraMap, _skillRace)){
								_raceCUltraMap[? _skillRace] = [];
							}
							array_push(_raceCUltraMap[? _skillRace], _skill);
						}
					}
					
					 // Determine Current Ultra Screen:
					for(var i = 0; i < maxp; i++){
						if(player_is_active(i)){
							var	_race     = player_get_race(i),
								_ultraGot = false;
								
							 // Check for Active Ultras:
							for(var _ultraIndex = ultra_count(_race) + (race_get_id(_race) == char_skeleton); _ultraIndex >= 1; _ultraIndex--){
								if(ultra_get(_race, _ultraIndex) != 0){
									_ultraGot = true;
									break;
								}
							}
							
							 // Check for Active Custom Ultras:
							if(!_ultraGot){
								with(_raceCUltraMap[? _race]){
									if(skill_get(self) != 0){
										array_push(_ultraGive, _race);
										_ultraGot = true;
										break;
									}
								}
							}
							
							 // Found Current Ultra Screen:
							if(!_ultraGot){
								_ultraPlayer = i;
								break;
							}
						}
					}
					
					 // Refresh Ultra Screen:
					if(array_length(_ultraGive)){
						var _lastLetterbox = game_letterbox;
						
						 // Temporarily Set Ultras:
						var _lastInstVars = [];
						game_deactivate();
						with(all){
							var _varsList = [];
							with(variable_instance_get_names(self)){
								array_push(_varsList, [self, variable_instance_get(other, self)]);
							}
							if(array_length(_varsList)){
								array_push(_lastInstVars, [self, _varsList]);
							}
						}
						for(var i = 0; i < array_length(_ultraGive); i++){
							ultra_set(_ultraGive[i], 1 + (_ultraGive[i] == "skeleton"), 1);
						}
						with(_lastInstVars){
							var	_inst     = self[0],
								_varsList = self[1];
								
							if(instance_exists(_inst)){
								with(_varsList){
									try{
										variable_instance_set(_inst, self[0], self[1]);
									}
									catch(_error){}
								}
							}
						}
						game_activate();
						
						 // Delete Ultra Icons:
						with(instances_matching(mutbutton, "creator", self)){
							instance_destroy();
						}
						
						 // Spawn Ultra Icons:
						var _lastVars = [];
						with(variable_instance_get_names(self)){
							array_push(_lastVars, [self, variable_instance_get(other, self)]);
						}
						with(self){
							event_perform(ev_create, 0);
						}
						if(instance_exists(self)){
							with(_lastVars){
								if(self[0] not in other){
									variable_instance_set(other, self[0], self[1]);
								}
							}
						}
						
						 // Reset Ultras:
						var _lastInstVars = [];
						game_deactivate();
						with(all){
							var _varsList = [];
							with(variable_instance_get_names(self)){
								array_push(_varsList, [self, variable_instance_get(other, self)]);
							}
							if(array_length(_varsList)){
								array_push(_lastInstVars, [self, _varsList]);
							}
						}
						for(var i = array_length(_ultraGive) - 1; i >= 0; i--){
							ultra_set(_ultraGive[i], 1 + (_ultraGive[i] == "skeleton"), 0);
						}
						with(_lastInstVars){
							var	_inst     = self[0],
								_varsList = self[1];
								
							if(instance_exists(_inst)){
								with(_varsList){
									try{
										variable_instance_set(_inst, self[0], self[1]);
									}
									catch(_error){}
								}
							}
						}
						game_activate();
						
						 // LETTERBOX:
						game_letterbox = _lastLetterbox;
						
						 // Gone:
						if(!instance_exists(self)){
							continue;
						}
					}
					
					 // Ensure That Grabbing the Final Custom Ultra Won't Spawn P1's Ultra Screen:
					for(var i = maxp - 1; i >= 0; i--){
						if(player_is_active(i)){
							if(_ultraPlayer == i){
								GameCont.endcount = max(GameCont.endcount, maxp - 1);
							}
							break;
						}
					}
					
					 // Spawn Custom Ultra Icons:
					var _ultraRaceList = ds_map_keys(_raceCUltraMap);
					for(var _ultraRaceIndex = 0; _ultraRaceIndex < array_length(_ultraRaceList); _ultraRaceIndex++){
						var	_ultraRace   = _ultraRaceList[_ultraRaceIndex],
							_ultraCount  = ultra_count(_ultraRace) - (race_get_id(_ultraRace) == char_random) + (race_get_id(_ultraRace) == char_skeleton),
							_ultraIcon   = instances_matching(instances_matching(EGSkillIcon, "creator", self), "race", _ultraRace),
							_ultraNormal = true,
							_cUltraList  = _raceCUltraMap[? _ultraRace];
							
						 // Check if Each Ultra Exists:
						for(var _ultraIndex = 1 + (race_get_id(_ultraRace) == char_skeleton); _ultraIndex <= _ultraCount; _ultraIndex++){
							if(!array_length(instances_matching(_ultraIcon, "skill", _ultraIndex))){
								_ultraNormal = false;
								break;
							}
						}
						
						 // Normally Spawn Icons:
						if(_ultraNormal && crown_current != crwn_destiny){
							for(var i = 0; i < array_length(_cUltraList); i++){
								if(skill_get_active(_cUltraList[i])){
									var _num = maxselect;
									
									 // Find Spot Next to Normal Icons:
									if(array_length(_ultraIcon)){
										_num = -1/0;
										with(_ultraIcon){
											if(num > _num){
												_num = num;
											}
										}
									}
									
									 // Spawn Custom Icon:
									maxselect++;
									custom_ultra_icon_create(_ultraRace, _cUltraList[i], _num + 1);
								}
							}
						}
						
						 // Randomly Replace Icons (Crown of Destiny):
						else{
							var _cUltraPool = ds_list_create();
							
							with(_cUltraList){
								if(skill_get_active(self)){
									ds_list_add(_cUltraPool, self);
								}
							}
							
							var	_cUltraPoolMax = ds_list_size(_cUltraPool),
								_cUltraPoolNum = 0,
								_ultraIconMax  = array_length(_ultraIcon),
								_ultraIconNum  = 0;
								
							ds_list_shuffle(_cUltraPool);
							
							for(var i = 0; i < _ultraIconMax; i++){
								if(random((_ultraIconMax - _ultraIconNum) + (_cUltraPoolMax - _cUltraPoolNum)) < (_cUltraPoolMax - _cUltraPoolNum)){
									var _icon = _ultraIcon[i];
									custom_ultra_icon_create(_ultraRace, _cUltraPool[| _cUltraPoolNum], _icon.num);
									instance_delete(_icon);
									_cUltraPoolNum++;
								}
								else _ultraIconNum++;
							}
							
							ds_list_destroy(_cUltraPool);
						}
					}
					
					ds_map_destroy(_raceCUltraMap);
				}
			}
		}
	}
	
#define custom_ultra_icon_create(_race, _skill, _num)
	/*
		Creates the given mutation as an ultra mutation icon
		Called from a LevCont that it will bind itself to
	*/
	
	if(instance_is(self, LevCont)){
		 // Shift Icons Over:
		var _iconList = instances_matching(mutbutton, "creator", self);
		if(array_length(instances_matching(_iconList, "num", _num))){
			with(instances_matching_ge(_iconList, "num", _num)){
				num++;
				if(alarm0 > 0){
					alarm0++;
				}
			}
		}
		
		 // Spawn Custom Icon:
		with(instance_create(0, 0, EGSkillIcon)){
			custom_ultra = true;
			creator      = other;
			skill        = 0;
			num          = _num;
			alarm0       = num + 1;
			name         = "";
			text         = "";
			
			 // Set Character:
			if(race_get_id(_race) != char_random){
				race = _race;
			}
			
			 // Set Sprite:
			if(is_string(_skill)){
				mod_script_call("skill", _skill, "skill_button");
			}
			else if(is_real(_skill)){
				sprite_index = sprSkillIcon;
				image_index  = _skill;
			}
			
			 // Secret Mutation Button:
			with(instance_create(x, y, SkillIcon)){
				var _varsList = variable_instance_get_names(other);
				for(var j = array_length(_varsList) - 1; j >= 0; j--){
					try{
						variable_instance_set(self, _varsList[j], variable_instance_get(other, _varsList[j], 0));
					}
					catch(_error){}
				}
				skill = _skill;
				name  = ((other.name == "") ? skill_get_name(_skill) : other.name);
				text  = ((other.text == "") ? skill_get_text(_skill) : other.text);
			}
			
			return self;
		}
	}
	
	return noone;
	
#define game_activate()
	/*
		Reactivates all instances and unpauses the game
	*/
	
	with(UberCont) with(self){
		event_perform(ev_alarm, 2);
	}
	
#define game_deactivate()
	/*
		Deactivates all objects, except GmlMods & most controllers
	*/
	
	with(UberCont) with(self){
		var	_lastIntro = opt_bossintros,
			_lastLoops = GameCont.loops,
			_player    = noone;
			
		 // Ensure Boss Intro Plays:
		opt_bossintros = true;
		GameCont.loops = 0;
		if(!instance_exists(Player)){
			_player = instance_create(0, 0, GameObject);
			with(_player){
				instance_change(Player, false);
			}
		}
		
		 // Call Boss Intro:
		with(instance_create(0, 0, GameObject)){
			instance_change(BanditBoss, false);
			with(self){
				event_perform(ev_alarm, 6);
			}
			sound_stop(sndBigBanditIntro);
			instance_delete(self);
		}
		
		 // Reset:
		alarm2         = -1;
		opt_bossintros = _lastIntro;
		GameCont.loops = _lastLoops;
		with(_player){
			instance_delete(self);
		}
		
		 // Unpause Game, Then Deactivate Objects:
		event_perform(ev_alarm, 2);
		event_perform(ev_draw, ev_draw_post);
	}