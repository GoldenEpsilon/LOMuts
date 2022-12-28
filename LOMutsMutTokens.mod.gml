#define init
	global.spr_blank = sprite_add("Sprites/TokenShop/Blank.png", 1, 12, 16)
	global.spr_leave = sprite_add("Sprites/TokenShop/Leave.png", 1, 12, 16)
	global.spr_restock = sprite_add("Sprites/TokenShop/Restock.png", 1, 12, 16)
	global.spr_experiment = sprite_add("Sprites/TokenShop/Experiment.png", 1, 12, 16)
	global.spr_ammo = sprite_add("Sprites/TokenShop/Ammo.png", 1, 12, 16)
	global.spr_supplies = sprite_add("Sprites/TokenShop/Supplies.png", 1, 12, 16)
	global.spr_ordnance = sprite_add("Sprites/TokenShop/Ordnance.png", 1, 12, 16)
	global.token = sprite_add_weapon("Sprites/Token.png", 7, 7)
	global.mutindex = 0;
	global.mutTokens = 0;
	global.prevLoops = 0;
	global.openingShop = 0;
	global.forceShopOpen = false;
	global.cancelOpen = true;
	
	global.ordnance = 0;
	
	global.shopOptions = [
		{name: "LEAVE", text: "FINISH SPENDING TOKENS#AND LEAVE", cost: 0, icon: global.spr_leave, on_select: script_ref_create(tokenshop_exit)},
		{name: "RESTOCK", text: "REROLL ALL SHOP OPTIONS", cost: 0, icon: global.spr_restock, on_select: script_ref_create(tokenshop_restock)},
		{name: "BUY ORDNANCE", text: "GET A#GIANT WEAPON CHEST", cost: 1, icon: global.spr_ordnance, on_select: script_ref_create(tokenshop_ordnance)},
		{name: "BUY SUPPLIES", text: "HEAL TO FULL#GAIN 250 RADS", cost: 1, icon: global.spr_supplies, on_select: script_ref_create(tokenshop_supplies)},
		{name: "BUY AMMO", text: "GAIN AMMO#(+10% MAX AMMO FOR EACH TYPE)", cost: 1, icon: global.spr_ammo, on_select: script_ref_create(tokenshop_ammo)},
		{name: "RETRAIN", text: "CHOOSE A DIFFERENT#NEURAL NETWORK", cost: 1, icon: global.spr_blank, on_select: script_ref_create(tokenshop_retrain)},
		{name: "EXPERIMENT", text: "REROLL A RANDOM MUTATION", cost: 2, icon: global.spr_experiment, on_select: script_ref_create(tokenshop_experiment)},
		{name: "DISRESPECT", text: "GAIN AN OUTCAST MUTATION#AND A BLIGHT", cost: 2, icon: global.spr_blank, on_select: script_ref_create(tokenshop_disrespect)},
		{name: "REROLL", text: "CHOOSE A MUTATION#TO RANDOMLY REROLL", cost: 2, icon: global.spr_experiment, on_select: script_ref_create(tokenshop_reroll)},
		//{name: "PRAY", text: "REROLL A BLIGHT", cost: 2, icon: global.spr_blank, on_select: script_ref_create(tokenshop_pray)},
		//{name: "RESET", text: "RESET TO LEVEL 1, LOSING MUTATIONS, AND#CHOOSE ONE MUTATION (OUT OF ALL) TO GAIN", cost: 2, icon: global.spr_blank, on_select: script_ref_create(tokenshop_reset)},
		//{name: "BRIBE", text: "HEAD TO YV'S CRIB", cost: 2, icon: global.spr_blank, on_select: script_ref_create(tokenshop_bribe)},
		//{name: "DECIDE", text: "LOSE 1 MUTATION#GAIN ONE MUTATION OUT OF ALL MUTATIONS", cost: 3, icon: global.spr_blank, on_select: script_ref_create(tokenshop_decide)},
		//{name: "BACKTRACK", text: "HEAD BACK TO 1-1#NEXT TIME YOU REACH 7-1", cost: 3, icon: global.spr_blank, on_select: script_ref_create(tokenshop_backtrack)},
		//{name: "REBEL", text: "GAIN AN OUTCAST MUTATION", cost: 4, icon: global.spr_blank, on_select: script_ref_create(tokenshop_rebel)},
		//{name: "EVOLVE", text: "GAIN TWO BLIGHTS#GAIN A MUTATION", cost: 4, icon: global.spr_blank, on_select: script_ref_create(tokenshop_evolve)},
		//{name: "WARP", text: "INSTANTLY LOOP", cost: 4, icon: global.spr_blank, on_select: script_ref_create(tokenshop_warp)},
		//{name: "REDEEM", text: "CHOOSE ONE OUTCAST MUTATION#IT IS NOW PERMANENTLY A NORMAL MUTATION#(PREVIOUSLY REDEEMED MUTATIONS BECOME OUTCAST)", cost: 4, icon: global.spr_blank, on_select: script_ref_create(tokenshop_redeem)},
		//{name: "CAST DOWN", text: "CHOOSE ONE NORMAL MUTATION#IT IS NOW PERMANENTLY AN OUTCAST MUTATION#(PREVIOUSLY CAST DOWN MUTATIONS BECOME NORMAL)", cost: 4, icon: global.spr_blank, on_select: script_ref_create(tokenshop_cast_down)},
		{name: "EMPOWER", text: "LOSE 1 MUTATION#POWER UP 1 MUTATION", cost: 5, icon: global.spr_blank, on_select: script_ref_create(tokenshop_empower)},
		//{name: "REVOLT", text: "GAIN ONE OUTCAST MUTATION#OUT OF ALL OUTCAST MUTATIONS", cost: 6, icon: global.spr_blank, on_select: script_ref_create(tokenshop_revolt)},
		{name: "DESTABILIZE", text: "REROLL ALL MUTATIONS#(CHOOSE FROM LEVELUP SCREEN)", cost: 6, icon: global.spr_experiment, on_select: script_ref_create(tokenshop_destabilize)},
		//{name: "TRANSMUTE", text: "IF YOU HAVE SOMEONE ELSE'S ULTRA MUTATION#REROLL IT", cost: 6, icon: global.spr_blank, on_select: script_ref_create(tokenshop_transmute)},
		//{name: "INFUSE", text: "LOSE 2 MUTATIONS#GAIN SOMEONE ELSE'S ULTRA MUTATION", cost: 8, icon: global.spr_blank, on_select: script_ref_create(tokenshop_infuse)},
		//{name: "ASCEND", text: "LOSE 2 MUTATIONS AT RANDOM#GAIN ANOTHER ULTRA", cost: 8, icon: global.spr_blank, on_select: script_ref_create(tokenshop_ascend)},
	];
	
	while(!mod_exists("mod", "lib")){wait(1);}
	script_ref_call(["mod", "lib", "getRef"], "mod", mod_current, "scr");
	
#define game_start
	global.mutindex = 0;
	global.mutTokens = 0;
	global.prevLoops = 0;
	global.cancelOpen = true;
	
	global.ordnance = 0;

#define level_start
	if(global.ordnance > 0){
		global.ordnance--;
		with(call(scr.instance_random, Player)){
			instance_create(x,y,GiantWeaponChest);
		}
	}

#define step
	if(instance_exists(CharSelect)){
		global.cancelOpen = true;
	}
	if(mod_variable_get("mod", "LOMuts", "canMutTokens")){
		if("mutindex" in GameCont && GameCont.mutindex > global.mutindex){
			global.mutindex = GameCont.mutindex;
			if(fork()){
				wait(0);
				if(GameCont.mutindex < global.mutindex){
					global.mutindex = GameCont.mutindex;
					exit;
				}
				if(irandom(1)){
					var choice = irandom(instance_number(SkillIcon) - 1);
					with(SkillIcon){
						if(choice == 0 && noinput <= 0 && (is_real(skill) || !mod_script_call("skill", skill, "skill_reusable") || ("NoToken" in self && NoToken))){
							MutationToken = true;
						}
						choice--;
					}
				}
				exit;
			}
		}
	}
	with(SkillIcon){
		if("MutationToken" in self && MutationToken	&& noinput <= 0){
			with(Player){
				if((button_pressed(index, "fire") && point_in_rectangle(mouse_x[index], mouse_y[index], other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)) || 
				button_pressed(index, "key" + string(other.num+1)) || 
				(other.creator.select == other.num && button_pressed(index, "okay"))){
					global.mutTokens += 2;
				}
			}
		}
	}
	if(!global.openingShop){
		if((global.prevLoops < GameCont.loops || global.forceShopOpen) && fork()){
			global.cancelOpen = false;
			global.forceShopOpen = false;
			global.mutTokens += 2;
			global.prevLoops = GameCont.loops;
			global.openingShop = 1;
			GameCont.endpoints++;
			while(GameCont.skillpoints > 0 || mod_variable_get("skill", "Mimicry", "activations") < skill_get("Mimicry")){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			while(skill_get("Mimicry") > 0 && mod_variable_get("skill", "Mimicry", "tempEndpoints") > 0){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			wait(0);
			while(!instance_exists(LevCont)){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			while(GameCont.endpoints > 1){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			if(global.cancelOpen){exit;}
			if(!instance_exists(LevCont)){
				instance_create(0,0,LevCont);
				with(GenCont){instance_destroy();}
			}
			GameCont.endpoints--;
			LevCont.maxselect = 0;
		    with(SkillIcon) instance_destroy();
		    with(EGSkillIcon) instance_destroy();
			with(LevCont){
				LevCont.maxselect = 3;
				name = "TokenShop";
				timer = 120;
				altpick = false;
				
				splat = instance_create(game_width/2, game_height-35, CustomObject);
				with(splat){
					creator = other;
					sprite_index = sprMutationSplat;
					image_index = image_number - 1;
					image_speed = 0;
					depth = -1001;
				}
				stock_shop();
			}
			GameCont.skillpoints++;
			exit;
		}
	}
	if(!instance_exists(LevCont) && GameCont.area != 0){
		global.openingShop = 0;
	}

#define draw_gui
	with(instances_matching(LevCont, "name", "TokenShop")){
		titley = 1000;
		if(GameCont.skillpoints > 1){
			GameCont.skillpoints--;
			with(splat){
				depth = 0;
			}
			with(instances_matching(instances_matching(CustomObject, "name", "tokenshopOption"), "alt", true)){
				instance_destroy();
			}
			break;
		}else{
			with(splat){
				depth = -1001;
			}
			//I should replace skillicons that show up with tokenshop mutation selections instead of destroying them
			with(SkillIcon){
				instance_destroy();
			}
			with(EGSkillIcon){
				instance_destroy();
			}
		}
		var _br = false;
		with(instances_matching(CustomObject, "name", "tokenshopOption")){
			if(_br){
				break;
			}
			if(!other.altpick xor alt){
				image_alpha = 1;
				if(instance_exists(self) && instance_exists(creator)){
					with(Player){
						if(instance_exists(other)){
							if(point_in_rectangle(mouse_x[index], mouse_y[index], other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom) || other.creator.select == other.num){
								other.creator.select = other.num;
								other.image_blend = c_white;
								other.y = game_height-22;
								if(other.alt || other.cost <= global.mutTokens){
									if((button_pressed(index, "fire") && point_in_rectangle(mouse_x[index], mouse_y[index], other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)) || 
									button_pressed(index, "key" + string(other.num+1)) || 
									(other.creator.select == other.num && button_pressed(index, "okay"))){
										other.y++;
										if(!other.alt){global.mutTokens -= other.cost;}
										script_ref_call(other.on_select, other);
										_br = true;
										break;
									}
								}
							}else{
								other.image_blend = c_gray;
								other.y = game_height-21;
							}
						}
					}
				}
			}else{
				image_alpha = 0;
				if(alt){
					instance_destroy();
				}
			}
		}
		if(instance_exists(self)){
			draw_set_halign(1);
			draw_set_font(fntBigName);
			draw_text_nt(game_width/2, 48, "@gTOKEN SHOP");
			draw_set_font(fntM);
			draw_text_nt(game_width/2, 88, "@wTokens: " + string(global.mutTokens));
			draw_set_halign(0);
			if(timer > 0){
				timer--;
			}
			with(instances_matching(CustomObject, "name", "tokenshopOption")){
				if(!other.altpick xor alt){
					if(creator.select == num){
						draw_set_halign(1);
						draw_text_nt(game_width/2, game_height - 83, _name);
						if(alt){
							draw_text_nt(game_width/2, game_height - 74, "@s"+text);
						}else{
							draw_text_nt(game_width/2, game_height - 74, "@wCOST: "+string(cost));
							draw_text_nt(game_width/2, game_height - 62, "@s"+text);
						}
						draw_set_halign(0);
					}
				}
			}
		}
	}
	
	with(instances_matching(SkillIcon, "MutationToken", true)){
		if(addy != 0 || "tokenIndex" not in self){
			tokenIndex = 0;
		}
		draw_sprite_ext(global.token, max(tokenIndex, 0), bbox_right-1, bbox_top-1+(addy ? 1 : 0), 1, 1, 0, addy ? c_gray : c_white, 1);
		if(tokenIndex > 7){
			tokenIndex = -25;
		}
		tokenIndex += current_time_scale * 0.4;
	}

#define tokenshop_option_create(chosenOption, optionNum, selectedOption)
	with(instance_create(game_width / 2 - 14 * optionNum + 12 + 28*chosenOption, game_height-20, CustomObject)){
		alt = false;
		name = "tokenshopOption";
		num = chosenOption;
		_name = selectedOption.name;
		text = selectedOption.text;
		cost = selectedOption.cost;
		creator = other;
		sprite_index = selectedOption.icon;
		mask_index = sprite_index;
		on_select = selectedOption.on_select;
		depth = -1002;
		image_speed = 0;
		return self;
	}
	
#define custom_option_create(chosenOption, optionNum, _skill, _on_select)
	with(instance_create(game_width / 2 - 14 * optionNum + 12 + 28*chosenOption, game_height-20, CustomObject)){
		alt = true;
		name = "tokenshopOption";
		num = chosenOption;
		skill = _skill;
		if(is_string(_skill) && mod_exists("skill", _skill)){
			 // Apply relevant scripts
			mod_script_call("skill", _skill, "skill_button");
			_name = mod_script_call("skill", _skill, "skill_name");
			text = mod_script_call("skill", _skill, "skill_text");
		}else if(is_real(_skill)){
			sprite_index = sprSkillIcon;
			image_index = _skill;
			_name = skill_get_name(_skill);
			text = skill_get_text(_skill);
		}
		image_speed = 0;
		creator = other;
		mask_index = sprite_index;
		on_select = _on_select;
		depth = -1002;
		return self;
	}

#define tokenshop_exit
	with(LevCont){
		if("splat" in self) with(splat){
			instance_destroy();
		}
		with(instances_matching(CustomObject, "name", "tokenshopOption")){
			instance_destroy();
		}
		instance_destroy();
	}
	GameCont.skillpoints--;
	if(GameCont.endpoints > 0){
		instance_create(0, 0, LevCont);
	}else{
		instance_create(0, 0, GenCont);
	}
	
#define tokenshop_restock
	with(instances_matching(CustomObject, "name", "tokenshopOption")){
		instance_destroy();
	}
	with(LevCont){
		stock_shop();
	}

#define stock_shop
	//leave
	tokenshop_option_create(array_length(instances_matching(CustomObject, "name", "tokenshopOption")), 5, global.shopOptions[0]);
	
	var possibleOptions = [];
	with(global.shopOptions){if(cost == 1){array_push(possibleOptions, self);}}
	tokenshop_option_create(array_length(instances_matching(CustomObject, "name", "tokenshopOption")), 5, possibleOptions[irandom(array_length(possibleOptions)-1)]);
	possibleOptions = [];
	with(global.shopOptions){if(cost == 2 || cost == 3){array_push(possibleOptions, self);}}
	tokenshop_option_create(array_length(instances_matching(CustomObject, "name", "tokenshopOption")), 5, possibleOptions[irandom(array_length(possibleOptions)-1)]);
	possibleOptions = [];
	with(global.shopOptions){if(cost >= 4){array_push(possibleOptions, self);}}
	tokenshop_option_create(array_length(instances_matching(CustomObject, "name", "tokenshopOption")), 5, possibleOptions[irandom(array_length(possibleOptions)-1)]);
	
	//restock
	tokenshop_option_create(array_length(instances_matching(CustomObject, "name", "tokenshopOption")), 5, global.shopOptions[1]).cost = 1;

#define tokenshop_ordnance
	global.ordnance++;

#define tokenshop_supplies
	with(Player){
		my_health = maxhealth;
		GameCont.rad += 250;
	}

#define tokenshop_ammo
	with(Player){
		for(var i = 0; i < array_length(ammo); i++){
			ammo[i] += ceil(typ_amax[i] * 0.10);
			typ_amax[i] += ceil(typ_amax[i] * 0.10);
		}
	}

#define tokenshop_disrespect
	var _skills = mod_get_names("skill");
	var _outcasts = [];
	with(_skills){
		if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast") && mod_script_exists("skill", self, "skill_avail") && mod_script_call("skill", self, "skill_avail")){
			array_push(_outcasts, self);
		}
	}
	if(!array_length(_outcasts)){
		trace("No muts left in outcast pool, refunding");
		global.mutTokens += 2;
	}
	with(LevCont){
		altpick = true;
			
		//this is the list of mutations we can use
		var mutList = _outcasts;
		
		//this is a list of the mutations we're using
		global.chosen = [];
		
		var s = mod_variable_get("mod", "Extra Mutation Options", "target");

		if(array_length(mutList) > 0){
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
						custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_disrespect));
						array_push(global.chosen, mutList[r]);
						//skill_create(mutList[r], instance_number(mutbutton));
						break;
					}
					attempts++;
				}
				if(attempts == 15){
					var r = irandom(array_length(mutList) - 1);
					custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_disrespect));
					//skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
				}
			}
		}
	}

#define select_disrespect(_button)
	skill_set(_button.skill, 1);
	
	with(instances_matching(instances_matching(CustomObject, "name", "tokenshopOption"), "alt", true)){
		instance_destroy();
	}
	
	var _skills = mod_get_names("skill");
	var _blights = [];
	with(_skills){
		if(mod_script_exists("skill", self, "skill_blight") && mod_script_call("skill", self, "skill_blight")){
			array_push(_blights, self);
		}
	}
	with(LevCont){
		altpick = true;
			
		//this is the list of mutations we can use
		var mutList = _blights;
		
		//this is a list of the mutations we're using
		global.chosen = [];
		
		var s = mod_variable_get("mod", "Extra Mutation Options", "target");

		if(array_length(mutList) > 0){
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
						custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_disrespect2));
						array_push(global.chosen, mutList[r]);
						//skill_create(mutList[r], instance_number(mutbutton));
						break;
					}
					attempts++;
				}
				if(attempts == 15){
					var r = irandom(array_length(mutList) - 1);
					custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_disrespect2));
					//skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
				}
			}
		}
	}

#define select_disrespect2(_button)
	skill_set(_button.skill, skill_get(_button.skill) + 1);
	with(LevCont){
		altpick = false;
	}

#define tokenshop_experiment
	var toChoose = []
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| ((!mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail"))
				&& (!mod_script_exists("skill", _skill, "skill_temp")
				|| !mod_script_call("skill", _skill, "skill_temp"))
				&& (!mod_script_exists("skill", _skill, "skill_outcast")
				|| !mod_script_call("skill", _skill, "skill_outcast")))
			){
				array_push(toChoose, _skill);
			}
		}
	}
	if(array_length(toChoose) < 1){
		trace("Not enough applicable mutations, refunding");
		global.mutTokens += 2;
		return;
	}
	var chosen = toChoose[irandom(array_length(toChoose) - 1)];
	skill_set(chosen, skill_get(chosen) - 1);
	with(LevCont){
		altpick = true;
			
		//this is the list of mutations we can use
		var mutList = call(scr.get_skills, true);
		
		//this is a list of the mutations we're using
		global.chosen = [];
		
		var s = mod_variable_get("mod", "Extra Mutation Options", "target");

		if(array_length(mutList) > 0){
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
						custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_choose));
						array_push(global.chosen, mutList[r]);
						//skill_create(mutList[r], instance_number(mutbutton));
						break;
					}
					attempts++;
				}
				if(attempts == 15){
					var r = irandom(array_length(mutList) - 1);
					custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_choose));
					//skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
				}
			}
		}
	}

#define select_choose(_button)
	skill_set(_button.skill, 1);
	with(LevCont){
		altpick = false;
	}

#define tokenshop_gamble
	if(irandom(1) == 1){
		trace(choose("Woo hoo!", "Bazinga", "You got it!", "Win", "Win!", "A Winner Is You", "+1 Mutation Tokens", "Beating the house today!"));
		global.mutTokens += 2;
	}else{
		trace(choose("Aww.", "Better luck next time", "Sucks to suck, loser", "Down the drain", "MISS!", "whoops", "Doh!", "Lose", "Loser! You're a loser!"));
	}

#define tokenshop_reroll
	with(LevCont){
		altpick = true;
			
		//this is the list of mutations the player has
		var mutList = [];
		
		//going down the list of mutations the player has in the UI
		var mutNum = 0;
		while(skill_get_at(mutNum) != null){
			//check to make sure it's not a modded ultra or a mutation that shouldn't be rerolled
			if(is_real(skill_get_at(mutNum)) || (is_string(skill_get_at(mutNum)) && mod_exists("skill", skill_get_at(mutNum)) && !mod_script_exists("skill", skill_get_at(mutNum), "skill_ultra") && (!mod_script_exists("skill", skill_get_at(mutNum), "skill_sacrifice") || !mod_script_call("skill", skill_get_at(mutNum), "skill_sacrifice")))){
				array_push(mutList, skill_get_at(mutNum));
			}
			mutNum++;
		}
		
		//this is a list of the mutations we're using
		global.chosen = [];
		
		var s = mod_variable_get("mod", "Extra Mutation Options", "target");

		if(array_length(mutList) > 0){
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
						custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_reroll));
						array_push(global.chosen, mutList[r]);
						//skill_create(mutList[r], instance_number(mutbutton));
						break;
					}
					attempts++;
				}
				if(attempts == 15){
					var r = irandom(array_length(mutList) - 1);
					custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_reroll));
					array_push(global.chosen, mutList[r]);
					//skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
				}
			}
		}else{
			trace("you have no mutations, refunding");
			global.mutTokens += 2;
		}
	}

#define select_reroll(_button)
	skill_set(_button.skill, skill_get(_button.skill) - 1);
	skill_set(call(scr.skill_decide, true), 1);
	with(LevCont){
		altpick = false;
	}

#define tokenshop_extract

#define tokenshop_empower
	var toChoose = []
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| ((!mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail"))
				&& (!mod_script_exists("skill", _skill, "skill_temp")
				|| !mod_script_call("skill", _skill, "skill_temp"))
				&& (!mod_script_exists("skill", _skill, "skill_sacrifice")
				|| mod_script_call("skill", _skill, "skill_sacrifice")))
			){
				array_push(toChoose, _skill)
			}
		}
	}
	if(array_length(toChoose) < 2){
		trace("Not enough applicable mutations, refunding");
		global.mutTokens += 5;
		return;
	}
	with(LevCont){
		altpick = true;
			
		//this is the list of mutations the player has
		var mutList = toChoose;
		
		//this is a list of the mutations we're using
		global.chosen = [];
		
		var s = mod_variable_get("mod", "Extra Mutation Options", "target");

		if(array_length(mutList) > 0){
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
						custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_empower));
						array_push(global.chosen, mutList[r]);
						//skill_create(mutList[r], instance_number(mutbutton));
						break;
					}
					attempts++;
				}
				if(attempts == 15){
					var r = irandom(array_length(mutList) - 1);
					custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_empower));
					array_push(global.chosen, mutList[r]);
					//skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
				}
			}
		}else{
			trace("you have no mutations, refunding");
			global.mutTokens += 2;
		}
	}

#define select_empower(_button)
	skill_set(_button.skill, skill_get(_button.skill) - 1);
	with(instances_matching(instances_matching(CustomObject, "name", "tokenshopOption"), "alt", true)){
		instance_destroy();
	}
	var toChoose = []
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| !mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail")
			){
				array_push(toChoose, _skill)
			}
		}
	}
	with(LevCont){
		altpick = true;
			
		//this is the list of mutations the player has
		var mutList = toChoose;
		
		//this is a list of the mutations we're using
		global.chosen = [];
		
		var s = mod_variable_get("mod", "Extra Mutation Options", "target");

		if(array_length(mutList) > 0){
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
						custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_empower2));
						array_push(global.chosen, mutList[r]);
						//skill_create(mutList[r], instance_number(mutbutton));
						break;
					}
					attempts++;
				}
				if(attempts == 15){
					var r = irandom(array_length(mutList) - 1);
					custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_empower2));
					array_push(global.chosen, mutList[r]);
					//skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
				}
			}
		}else{
			trace("you have no mutations, refunding");
			global.mutTokens += 2;
		}
	}

#define select_empower2(_button)
	skill_set(_button.skill, skill_get(_button.skill) + 1);
	with(LevCont){
		altpick = false;
	}

#define tokenshop_rebel

#define tokenshop_evolve
	GameCont.skillpoints++;

#define tokenshop_reset
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| !mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail")
			){
				skill_set(_skill, false);
				i--;
			}
		}
	}
	GameCont.rad = 0;
	GameCont.level = 1;
	GameCont.mutindex = 0;

#define tokenshop_backtrack

#define tokenshop_revolt

#define tokenshop_bribe

#define tokenshop_warp

#define tokenshop_infuse

#define tokenshop_redeem

#define tokenshop_decide

#define tokenshop_ascend

#define tokenshop_retrain
	var toChoose = []
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				mod_script_exists("skill", _skill, "skill_neural")
			){
				array_push(toChoose, _skill);
			}
		}
	}
	if(array_length(toChoose) < 1){
		trace("Not enough applicable mutations, refunding");
		global.mutTokens += 1;
		return;
	}
	var chosen = toChoose[irandom(array_length(toChoose) - 1)];
	skill_set(chosen, skill_get(chosen) - 1);
	with(LevCont){
		altpick = true;
			
		//this is the list of mutations we can use
		var mutList = [];
		var _skills = mod_get_names("skill");
		with(_skills){
			if(!skill_get(self) && mod_script_exists("skill", self, "skill_neural")){
				array_push(mutList, self);
			}
		}
		
		//this is a list of the mutations we're using
		global.chosen = [];
		
		var s = mod_variable_get("mod", "Extra Mutation Options", "target");

		if(array_length(mutList) > 0){
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
						custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_choose));
						array_push(global.chosen, mutList[r]);
						//skill_create(mutList[r], instance_number(mutbutton));
						break;
					}
					attempts++;
				}
				if(attempts == 15){
					var r = irandom(array_length(mutList) - 1);
					custom_option_create(array_length(global.chosen), s, mutList[r], script_ref_create(select_choose));
					//skill_create(mutList[irandom(array_length(mutList) - 1)], instance_number(mutbutton));
				}
			}
		}
	}

#define tokenshop_transmute

#define tokenshop_destabilize
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| (!mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail"))
				&& (!mod_script_exists("skill", _skill, "skill_temp")
				|| !mod_script_call("skill", _skill, "skill_temp"))
				&& (!mod_script_exists("skill", _skill, "skill_ultra")
				|| !mod_script_call("skill", _skill, "skill_ultra"))
			){
				skill_set(_skill, 0);
				GameCont.skillpoints++;
				i--;
			}
		}
	}

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
			text = mod_script_call("skill", _skill, "skill_text");
		}else if(is_real(_skill)){
			sprite_index = sprSkillIcon;
			image_index = _skill;
			name = skill_get_name(_skill);
			text = skill_get_text(_skill);
		}
	}

	
//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call