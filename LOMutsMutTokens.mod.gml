#define init
	global.blank = sprite_add("Sprites/Outcast/Blank.png", 1, 12, 16)
	global.token = sprite_add_weapon("Sprites/Token.png", 7, 7)
	global.mutindex = 0;
	global.mutTokens = 0;
	global.prevLoops = 0;
	global.openingShop = 0;
	
	global.ordnance = 0;
	
	global.shopOptions = [
		{name: "LEAVE", desc: "FINISH SPENDING TOKENS#AND LEAVE", cost: 0, icon: global.blank, on_select: script_ref_create(tokenshop_exit)},
		{name: "BUY ORDNANCE", desc: "GET A#GIANT WEAPON CHEST", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_ordnance)},
		{name: "BUY SUPPLIES", desc: "HEAL TO FULL#GAIN 250 RADS", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_supplies)},
		{name: "BUY AMMO", desc: "GAIN AMMO#(+25% MAX AMMO FOR EACH TYPE)", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_ammo)},
		{name: "DISRESPECT", desc: "GAIN A RANDOM#OUTCAST MUTATION", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_disrespect)},
		{name: "EXPERIMENT", desc: "REROLL A MUTATION#AT RANDOM", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_experiment)},
		{name: "GAMBLE", desc: "GAMBLE A#MUTATION TOKEN", cost: 1, icon: global.blank, on_select: script_ref_create(tokenshop_gamble)},
		//{name: "REROLL", desc: "REROLL A MUTATION#OUT OF FOUR", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_reroll)},
		//{name: "EXTRACT", desc: "LOSE 2 MUTATIONS#GAIN SOMEONE ELSE'S#ULTRA MUTATION", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_extract)},
		{name: "EMPOWER", desc: "LOSE 1 MUTATION#POWER UP 1 MUTATION", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_empower)},
		//{name: "REBEL", desc: "GAIN AN OUTCAST MUTATION", cost: 2, icon: global.blank, on_select: script_ref_create(tokenshop_rebel)},
		{name: "EVOLVE", desc: "GAIN A MUTATION", cost: 3, icon: global.blank, on_select: script_ref_create(tokenshop_evolve)},
		{name: "RESET", desc: "RESET TO LEVEL 1#LOSING MUTATIONS", cost: 3, icon: global.blank, on_select: script_ref_create(tokenshop_reset)},
		//{name: "BACKTRACK", desc: "HEAD BACK TO 1-1", cost: 3, icon: global.blank, on_select: script_ref_create(tokenshop_backtrack)},
		//{name: "REVOLT", desc: "GAIN ONE OUTCAST MUTATION#OUT OF ALL OUTCAST MUTATIONS", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_revolt)},
		//{name: "BRIBE", desc: "HEAD TO YV'S CRIB", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_bribe)},
		//{name: "WARP", desc: "INSTANTLY LOOP", cost: 4, icon: global.blank, on_select: script_ref_create(tokenshop_warp)},
		//{name: "INFUSE", desc: "GAIN SOMEONE ELSE'S ULTRA MUTATION", cost: 5, icon: global.blank, on_select: script_ref_create(tokenshop_infuse)},
		//{name: "REDEEM", desc: "CHOOSE ONE OUTCAST MUTATION#IT IS NOW A NORMAL MUTATION", cost: 6, icon: global.blank, on_select: script_ref_create(tokenshop_redeem)},
		//{name: "ASCEND", desc: "GAIN ANOTHER ULTRA", cost: 6, icon: global.blank, on_select: script_ref_create(tokenshop_ascend)},
		{name: "DESTABILIZE", desc: "REROLL ALL MUTATIONS", cost: 6, icon: global.blank, on_select: script_ref_create(tokenshop_destabilize)},
	];
	
	while(!mod_exists("mod", "lib")){wait(1);}
	script_ref_call(["mod", "lib", "getRef"], "mod", mod_current, "scr");
	
#define game_start
	global.mutindex = 0;
	global.mutTokens = 0;
	global.prevLoops = 0;
	
	global.ordnance = 0;

#define level_start
	if(global.ordnance > 0){
		global.ordnance--;
		with(call(scr.instance_random, Player)){
			instance_create(x,y,GiantWeaponChest);
		}
	}

#define step
	if(mod_variable_get("mod", "LOMuts", "canMutTokens")){
		if(GameCont.mutindex > global.mutindex){
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
					global.mutTokens++;
				}
			}
		}
	}
	if(!global.openingShop && global.mutTokens > 0 && GameCont.endpoints <= 0){
		if(global.prevLoops < GameCont.loops && fork()){
			global.prevLoops = GameCont.loops;
			global.openingShop = 1;
			while(GameCont.skillpoints > 0){
				wait(0);
			}
			GameCont.skillpoints++;
			while(!instance_exists(LevCont)){
				wait(0);
			}
			LevCont.maxselect = 0;
			GameCont.skillpoints--;
		    with(SkillIcon) instance_destroy();
			with(LevCont){
				name = "TokenShop";
				var optionNum = 4;
				LevCont.maxselect = optionNum - 1;
				
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
		if(instance_exists(self)){
			draw_set_halign(1);
			draw_set_font(fntBigName);
			draw_text_nt(game_width/2, 48, "@gTOKEN SHOP");
			draw_set_font(fntM);
			draw_text_nt(game_width/2, 88, "@wTokens: " + string(global.mutTokens));
			draw_set_halign(0);
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
	instance_create(0, 0, GenCont);

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
		if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
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
				i--;
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

#define tokenshop_ascend

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

	
//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call