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
	
	while(!mod_exists("mod", "lib")){wait(1);}
	script_ref_call(["mod", "lib", "getRef"], "mod", mod_current, "scr");
	
#define game_start
	global.mutindex = 0;
	global.mutTokens = 0;
	global.prevLoops = 0;

#define step
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
						if(choice == 0 && noinput <= 0 && (is_real(skill) || !mod_script_call("skill", skill, "skill_reusable")) && !("NoToken" in self && NoToken)){
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
					GameCont.rad += 50;
					global.mutTokens += 1;
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