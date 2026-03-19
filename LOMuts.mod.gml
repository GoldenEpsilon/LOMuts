#define init
	global.marker = sprite_add("Sprites/Marker.png", 4, 3, 3)
	//this is set to true when lib is done loading, check this before using lib in step events and such
	global.libLoaded = false;
	if(fork()){
		//wait for lib to be loaded, first of all.
		while(!mod_exists("mod", "lib")){wait(1);}

		//This tells lib to check this mod for hooks and to give the global variable (in this case global.scr) the list of functions lib can use
		script_ref_call(["mod", "lib", "getRef"], "mod", mod_current, "scr");

		//This is where you put what modules you want to load.
		var modules = ["libImprovements", "libMuts", "libStats", "libSettings", "libWeps", "libPickups", "libAutoUpdate"];
		with(modules) {
			call(scr.import, self);
		}
		//Lib is done loading, set the global variable.
		global.libLoaded = true;
		exit;
	}

	global.canMutTokens = true;
	global.showStackIndicator = false;
	global.canOutcast = 0;
	global.prevCanOutcast = 0;
	while(!global.libLoaded){wait(1);}
	call(scr.add_setting, "LOMuts", "canMutTokens", "Mutation Tokens");
	call(scr.add_setting, "LOMuts", "showStackIndicator", "Stack Indicator");
	call(scr.autoupdate, "LOMuts", "GoldenEpsilon/LOMuts/master");
	game_start();
	
#define game_start
	global.canOutcast = 0;
	global.prevCanOutcast = 1;

#define step
	//TODO: If all skill icons are reusable skill icons, reroll one of them
	var allreusable = true;
	with(SkillIcon){
		if(is_string(skill) && mod_script_exists("skill", skill, "skill_reusable") && mod_script_call("skill", skill, "skill_reusable")){
			noinput = 2;
			with(Player){
				if((button_pressed(index, "fire") && point_in_rectangle(mouse_x[index], mouse_y[index], other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)) || 
				button_pressed(index, "key" + string(other.num+1)) || 
				(other.creator.select == other.num && button_pressed(index, "okay"))){
					//TODO: https://discord.com/channels/846661738803626014/882447494892642315/917906721538727957
					mod_script_call("skill", other.skill, "skill_take");
					other.addy += 5;
				}
			}
		} else {
			allreusable = false;
		}
	}
	if allreusable {
		with(SkillIcon){
			tskill = call(scr.skill_decide);
			while(array_length_1d(instances_matching(SkillIcon,"skill",tskill)) > 0 || skill_get(tskill) > 0 || !skill_get_active(tskill)){
				tskill = call(scr.skill_decide);
			}
			skill=tskill

			name  = skill_get_name(skill)
			if is_real(skill){
				if(skill >= 0){
					sprite_index = sprSkillIcon
					image_index = skill
					text = skill_get_text(skill);
				}
			}else{
				mod_script_call("skill",skill,"skill_button")
				text = mod_script_call("skill",skill,"skill_text")
			}
		}
	}
	if(global.canOutcast != global.prevCanOutcast){
		global.prevCanOutcast = global.canOutcast;
		if(global.canOutcast == 0){
			var _skills = mod_get_names("skill");
			with(_skills){
				if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
					skill_set_active(self, false);
				}
			}
		}else{
			var _skills = mod_get_names("skill");
			with(_skills){
				if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
					skill_set_active(self, true);
				}
			}
		}
	}

#define draw
	with(instances_matching(hitme, "marked", true)){
		if("markTimer" not in self){
			markTimer = 10;
		}

		var drawx = x;
		var drawy = y;
		if("markmovefin" not in self || !markmovefin){
			if("markx" in self && "marky" in self){
				drawx = lerp(markx, drawx, 6*current_time_scale/point_distance(x,y,markx,marky));
				markx = drawx;
				
				drawy = lerp(marky, drawy, 6*current_time_scale/point_distance(x,y,markx,marky));
				marky = drawy;

				if (point_distance(x,y,markx,marky) < 5){
					markmovefin = true;
				}
			}
		}
		
		draw_sprite_ext(global.marker, 0, bbox_left - markTimer - x + drawx, bbox_top - markTimer - y + drawy, 1, 1, 0, c_white, (10-markTimer)/10);
		draw_sprite_ext(global.marker, 1, bbox_right + markTimer + 1 - x + drawx, bbox_top - markTimer - y + drawy, 1, 1, 0, c_white, (10-markTimer)/10);
		draw_sprite_ext(global.marker, 2, bbox_left - markTimer - x + drawx, bbox_bottom + markTimer + 2 - y + drawy, 1, 1, 0, c_white, (10-markTimer)/10);
		draw_sprite_ext(global.marker, 3, bbox_right + markTimer + 1 - x + drawx, bbox_bottom + markTimer + 2 - y + drawy, 1, 1, 0, c_white, (10-markTimer)/10);
		
		if(markTimer > 0){
			markTimer -= current_time_scale;
		}else{
			markTimer = 0;
		}
	}



#define player_hud(_player, _hudIndex, _hudSide)
	mod_script_call("skill", "Duplicators", "player_hud", _player, _hudIndex, _hudSide);
	
#define draw_gui
	 // Player HUD Management:
	if(instance_exists(Player) && !instance_exists(PopoScene) && !instance_exists(MenuGen)){
		if(instance_exists(TopCont) || instance_exists(GenCont) || instance_exists(LevCont)){
			var _hudFade  = 0,
			    _hudIndex = 0,
			    _lastSeed = random_get_seed();
			    
			 // Game Win Fade Out:
			if(array_length(instances_matching(TopCont, "fadeout", true))){
				with(TopCont){
					_hudFade = clamp(fade, 0, 1);
				}
			}
			if(_hudFade > 0){
				 // GMS1 Partial Fix:
				try if(!null){}
				catch(_error){
					_hudFade = min(_hudFade, round(_hudFade));
				}
				
				 // Dim Drawing:
				if(_hudFade > 0){
					draw_set_fog(true, c_black, 0, 16000 / _hudFade);
				}
			}
			
			 // Draw Player HUD:
			for(var _isOnline = 0; _isOnline <= 1; _isOnline++){
				for(var _index = 0; _index < maxp; _index++){
					if(
						player_is_active(_index)
						&& (_hudIndex < 2 || !instance_exists(LevCont))
						&& (player_is_local_nonsync(_index) ^^ _isOnline)
					){
						var _hudVisible = false;
						
						 // HUD Visibility:
						for(var i = 0; true; i++){
							var _local = player_find_local_nonsync(i);
							if(!player_is_active(_local)){
								break;
							}
							if(player_get_show_hud(_index, _local)){
								_hudVisible = true;
								break;
							}
						}
						
						 // Draw HUD:
						if(_hudVisible || _isOnline == 0){
							if(_hudVisible){
								var _player = player_find(_index);
								if(instance_exists(_player)){
									 // Rad Canister / Co-op Offsets:
									var _playerNum = 0;
									for(var i = 0; i < maxp; i++){
										_playerNum += player_is_active(i);
									}
									if(_playerNum <= 1){
										d3d_set_projection_ortho(
											view_xview_nonsync,
											view_yview_nonsync,
											game_width,
											game_height,
											0
										);
									}
									else draw_set_projection(2, _index);
									
									 // Draw:
									player_hud(_player, _hudIndex, _hudIndex % 2);
									
									draw_reset_projection();
								}
							}
							_hudIndex++;
						}
					}
				}
			}
			if(_hudFade > 0){
				draw_set_fog(false, 0, 0, 0);
			}
			random_set_seed(_lastSeed);
		}
	}
	

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call