#define init
	global.blank = sprite_add("Sprites/Outcast/Blank.png", 1, 12, 16)
	global.token = sprite_add_weapon("Sprites/Token.png", 7, 7)
	global.mutindex = 0;
	global.mutTokens = 0;
	global.prevLoops = 0;
	global.openingShop = 0;
	global.tempendpoints = 0;
	global.forceShopOpen = false;
	global.cancelOpen = true;
	
	global.ordnance = 0;
	
	global.shopOptions = [
		{name: "LEAVE", desc: "FINISH SPENDING TOKENS#AND LEAVE", cost: 0, icon: global.blank, on_select: script_ref_create(tokenshop_exit)},
		{name: "BUY ORDNANCE", desc: "GET A#GIANT WEAPON CHEST", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_ordnance)},
		{name: "BUY SUPPLIES", desc: "HEAL TO FULL#GAIN 250 RADS", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_supplies)},
		{name: "BUY AMMO", desc: "GAIN AMMO#(+25% MAX AMMO FOR EACH TYPE)", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_ammo)},
		{name: "EXPERIMENT", desc: "REROLL A MUTATION AT RANDOM", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_experiment)},//todo: make the outcome random
		//{name: "RETRAIN", desc: "CHOOSE A DIFFERENT#NEURAL NETWORK", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_retrain)},
		{name: "DISRESPECT", desc: "GAIN A RANDOM#OUTCAST MUTATION", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_disrespect)},//todo: make it like leprosy
		{name: "REROLL", desc: "CHOOSE A MUTATION#TO REROLL RANDOMLY", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_reroll)},
		{name: "RESET", desc: "RESET TO LEVEL 1, LOSING MUTATIONS, AND#CHOOSE ONE MUTATION (OUT OF ALL) TO GAIN", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_reset)},
		//{name: "BRIBE", desc: "HEAD TO YV'S CRIB", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_bribe)},
		//{name: "DECIDE", desc: "LOSE 1 MUTATION#GAIN ONE MUTATION OUT OF ALL MUTATIONS", cost: 3, icon: global.blank, on_select: script_ref_create(tokenshop_decide)},
		//{name: "BACKTRACK", desc: "HEAD BACK TO 1-1#NEXT TIME YOU REACH 7-1", cost: 3, icon: global.blank, on_select: script_ref_create(tokenshop_backtrack)},
		//{name: "REBEL", desc: "GAIN AN OUTCAST MUTATION", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_rebel)},
		//{name: "EVOLVE", desc: "LOSE TWO OUTCAST MUTATIONS#GAIN A MUTATION", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_evolve)},
		//{name: "WARP", desc: "INSTANTLY LOOP", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_warp)},
		//{name: "REDEEM", desc: "CHOOSE ONE OUTCAST MUTATION#IT IS NOW PERMANENTLY A NORMAL MUTATION#(PREVIOUSLY REDEEMED MUTATIONS BECOME OUTCAST)", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_redeem)},
		//{name: "CAST DOWN", desc: "CHOOSE ONE NORMAL MUTATION#IT IS NOW PERMANENTLY AN OUTCAST MUTATION#(PREVIOUSLY CAST DOWN MUTATIONS BECOME NORMAL)", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_cast_down)},
		{name: "EMPOWER", desc: "LOSE 1 MUTATION#POWER UP 1 MUTATION", cost: 5, icon: global.blank, on_select: script_ref_create(tokenshop_empower)},
		//{name: "REVOLT", desc: "GAIN ONE OUTCAST MUTATION#OUT OF ALL OUTCAST MUTATIONS", cost: 6, icon: global.blank, on_select: script_ref_create(tokenshop_revolt)},
		{name: "DESTABILIZE", desc: "REROLL ALL MUTATIONS#(CHOOSE FROM LEVELUP SCREEN)", cost: 6, icon: global.blank, on_select: script_ref_create(tokenshop_destabilize)},
		//{name: "TRANSMUTE", desc: "IF YOU HAVE SOMEONE ELSE'S ULTRA MUTATION#REROLL IT", cost: 6, icon: global.blank, on_select: script_ref_create(tokenshop_transmute)},
		//{name: "INFUSE", desc: "LOSE 2 MUTATIONS#GAIN SOMEONE ELSE'S ULTRA MUTATION", cost: 8, icon: global.blank, on_select: script_ref_create(tokenshop_infuse)},
		//{name: "ASCEND", desc: "LOSE 2 MUTATIONS AT RANDOM#GAIN ANOTHER ULTRA", cost: 8, icon: global.blank, on_select: script_ref_create(tokenshop_ascend)},
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
						if(choice == 0 && noinput <= 0 && (is_real(skill) || !mod_script_call("skill", skill, "skill_reusable"))){
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
			while(GameCont.skillpoints > 0 || mod_variable_get("skill", "Mimicry", "activations") < skill_get("Mimicry")){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			while(skill_get("Mimicry") > 0 && mod_variable_get("skill", "Mimicry", "tempEndpoints") > 0){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			wait(0);
			GameCont.skillpoints++;
			while(!instance_exists(LevCont)){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			while(GameCont.endpoints > 0){
				if(global.cancelOpen){exit;}
				wait(0);
			}
			if(global.cancelOpen){exit;}
			if(!instance_exists(LevCont)){
				instance_create(0,0,LevCont);
				with(GenCont){instance_destroy();}
			}
			GameCont.skillpoints--;
			LevCont.maxselect = 0;
			global.tempendpoints = GameCont.endpoints;
			GameCont.endpoints = 0;
		    with(SkillIcon) instance_destroy();
		    with(EGSkillIcon) instance_destroy();
			with(LevCont){
				name = "TokenShop";
				var optionNum = 4;
				LevCont.maxselect = optionNum - 1;
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
				
				options = [];
				array_push(options, tokenshop_option_create(array_length(options), optionNum, global.shopOptions[0]));
				var possibleOptions = [];
				with(global.shopOptions){if(cost == 1){array_push(possibleOptions, self);}}
				array_push(options, tokenshop_option_create(array_length(options), optionNum, possibleOptions[irandom(array_length(possibleOptions)-1)]));
				possibleOptions = [];
				with(global.shopOptions){if(cost == 2 || cost == 3){array_push(possibleOptions, self);}}
				array_push(options, tokenshop_option_create(array_length(options), optionNum, possibleOptions[irandom(array_length(possibleOptions)-1)]));
				possibleOptions = [];
				with(global.shopOptions){if(cost >= 4){array_push(possibleOptions, self);}}
				array_push(options, tokenshop_option_create(array_length(options), optionNum, possibleOptions[irandom(array_length(possibleOptions)-1)]));
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
		if(!altpick){
			with(options){
				if(instance_exists(self) && instance_exists(creator)){
					with(Player){
						if(instance_exists(other)){
							if(point_in_rectangle(mouse_x[index], mouse_y[index], other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom) || other.creator.select == other.num){
								other.creator.select = other.num;
								other.image_blend = c_white;
								other.y = game_height-22;
								if(other.cost <= global.mutTokens){
									if((button_pressed(index, "fire") && point_in_rectangle(mouse_x[index], mouse_y[index], other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)) || 
									button_pressed(index, "key" + string(other.num+1)) || 
									(other.creator.select == other.num && button_pressed(index, "okay"))){
										other.y++;
										global.mutTokens -= other.cost;
										script_ref_call(other.on_select);
									}
								}
							}else{
								other.image_blend = c_gray;
								other.y = game_height-21;
							}
						}
					}
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
			if(global.tempendpoints > 0 && timer % 10 > 5){
				draw_set_halign(1);
				draw_text_nt(game_width/2, 108, "@gYou can pick your ultras#@gafter leaving");
				draw_set_halign(0);
			}
			if(!altpick){
				with(options){
					if(creator.select == num){
						draw_set_halign(1);
						draw_text_nt(game_width/2, game_height - 83, name);
						draw_text_nt(game_width/2, game_height - 74, "@wCOST: "+string(cost));
						draw_text_nt(game_width/2, game_height - 62, "@s"+desc);
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
		num = chosenOption;
		name = selectedOption.name;
		desc = selectedOption.desc;
		cost = selectedOption.cost;
		creator = other;
		sprite_index = selectedOption.icon;
		mask_index = sprite_index;
		on_select = selectedOption.on_select;
		depth = -1002;
		return self;
	}

#define tokenshop_exit
	with(LevCont){
		if("splat" in self) with(splat){
			instance_destroy();
		}
		if("options" in self) with(options){
			instance_destroy();
		}
		instance_destroy();
	}
	GameCont.skillpoints--;
	GameCont.endpoints = global.tempendpoints;
	if(GameCont.endpoints > 0){
		instance_create(0, 0, LevCont);
	}else{
		instance_create(0, 0, GenCont);
	}

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
			ammo[i] += ceil(typ_amax[i] * 0.25);
			typ_amax[i] += ceil(typ_amax[i] * 0.25);
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
	if(array_length(_outcasts)){
		var chosen = _outcasts[call(scr.seeded_random, GameCont.level + GameCont.mutindex, 0, array_length(_outcasts)-1, 1)]
		skill_set(chosen, 1);
	}else{
		trace("No muts left in outcast pool, refunding");
		global.mutTokens++;
	}

#define tokenshop_experiment
	var toChoose = []
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| !mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail")
				|| !mod_script_exists("skill", _skill, "skill_temp")
				|| !mod_script_call("skill", _skill, "skill_temp")
				|| !mod_script_exists("skill", _skill, "skill_outcast")
				|| !mod_script_call("skill", _skill, "skill_outcast")
			){
				array_push(toChoose, _skill)
				i--;
			}
		}
	}
	if(array_length(toChoose) < 1){
		trace("Not enough applicable mutations, refunding");
		global.mutTokens++;
		return;
	}
	var chosen = toChoose[irandom(array_length(toChoose) - 1)];
	skill_set(chosen, skill_get(chosen) - 1);
	GameCont.skillpoints++;

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
			
		if(fork()){
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
					skill_set(chosen, 0);
					GameCont.skillpoints++;
				}
			}
		    exit;
		}
	}

#define tokenshop_extract

#define tokenshop_empower
	var toChoose = []
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		var _skill = skill_get_at(i);
		if(skill_get_active(_skill)){
			if(
				!is_string(_skill)
				|| !mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail")
				|| !mod_script_exists("skill", _skill, "skill_temp")
				|| !mod_script_call("skill", _skill, "skill_temp")
			){
				array_push(toChoose, _skill)
			}
		}
	}
	if(array_length(toChoose) < 2){
		trace("Not enough applicable mutations, refunding");
		global.mutTokens++;
		return;
	}
	var chosen = toChoose[irandom(array_length(toChoose) - 1)];
	skill_set(chosen, skill_get(chosen) - 1);
	var chosen2 = toChoose[irandom(array_length(toChoose) - 1)];
	while(chosen == chosen2){
		chosen2 = toChoose[irandom(array_length(toChoose) - 1)];
	}
	skill_set(chosen2, skill_get(chosen2) + 1);

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