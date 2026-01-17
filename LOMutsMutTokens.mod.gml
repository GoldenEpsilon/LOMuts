#define init
	global.token_rad = sprite_add_weapon("Sprites/Token.png", 7, 7)
	global.token_reroll = sprite_add_weapon("Sprites/Token_Reroll.png", 7, 7)
	global.token_reroll_wepmut = sprite_add_weapon("Sprites/Token_Reroll_Wepmut.png", 10, 10)
	global.mutindex = 0;
	global.mutTokens = 0;

	global.rerolls = [];
	global.rerolled = [];
	
	while(!mod_exists("mod", "lib")){wait(1);}
	script_ref_call(["mod", "lib", "getRef"], "mod", mod_current, "scr");
	
#define game_start
	global.mutindex = 0;
	global.mutTokens = 0;
	global.rerolls = [];
	global.rerolled = [];

#define step
	if(GameCont.level >= 10){
		with(global.rerolls){
			if(skill_get(self) > 0){
				GameCont.skillpoints += 1;
				skill_set(self, skill_get(self) - 1);
				array_push(global.rerolled, self);
			}
		}
		global.rerolls = [];
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
				var retake = false;
				with(SkillIcon){
					if(("foldermut" not in self || foldermut != true) && choice == 0 && noinput <= 0 && array_length(global.rerolled) > 0){
						retake = true;
						if(skill == global.rerolled[0]) {
							retake = false;
							break;
						}
					}
				}
				if(retake && array_length(global.rerolled) > 0){
					skill_create(array_shift(global.rerolled), instance_number(mutbutton));
				}
				if(irandom(1) > 0 && GameCont.level < 10){
					var choice = irandom(instance_number(SkillIcon) - 1);
					with(SkillIcon){
						if(("foldermut" not in self || foldermut != true) && choice == 0 && noinput <= 0 && (is_real(skill) || !mod_script_call("skill", skill, "skill_reusable")) && !("NoToken" in self && NoToken)){
							MutationToken = true;
							MutationTokenType = irandom(1);
							if(GameCont.wepmuts >= 1){
								if((is_real(skill) && (skill == mut_long_arms || skill == mut_boiling_veins || skill == mut_shotgun_shoulders || skill == mut_recycle_gland || skill == mut_laser_brain || skill == mut_bolt_marrow)) || mod_script_call("skill", skill, "skill_wepspec")){
									rerollmut = -4;
									var i = 0;
									var _skill = skill_get_at(i);
									while(!is_undefined(_skill)){
										if((is_real(_skill) && (_skill == mut_long_arms || _skill == mut_boiling_veins || _skill == mut_shotgun_shoulders || _skill == mut_recycle_gland || _skill == mut_laser_brain || _skill == mut_bolt_marrow)) || mod_script_call("skill", _skill, "skill_wepspec")) {
											rerollmut = _skill;
											break;
										}
										i++;
										_skill = skill_get_at(i);
									}
									if(rerollmut != -4 && irandom(1)){
										MutationTokenType = 2;
										MutationTokenMut = rerollmut;
									}
								}
							}
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
					switch(other.MutationTokenType){
						case 0:
							GameCont.rad += 50;
							repeat(50){
								with(instance_create(other.x+random(other.sprite_width), other.y+random(other.sprite_height), CustomObject)){
									depth = -10000;
									image_speed = 0;
									sprite_index = sprRad;
									image_angle = random(360);
									rot_speed = random(30) - 15;
									direction = random(360);
									speed = 5+random(10);
									friction = 0.9;
									on_step = rad_effect_step;
								}
							}
							break;
						case 1:
							array_push(global.rerolls, other.skill);
							break;
						case 2:
							if("MutationTokenMut" in other && skill_get(other.MutationTokenMut)){
								skill_set(other.MutationTokenMut, skill_get(other.MutationTokenMut) - 1);
								GameCont.skillpoints += 1;
							}
							break;
						default:
							global.mutTokens += 1;
							break;
					}
				}
			}
		}
	}

#define draw_gui
	with(instances_matching(SkillIcon, "MutationToken", true)){
		if(addy != 0 || "tokenIndex" not in self){
			tokenIndex = 0;
		}
		var spr;
		switch(MutationTokenType){
			case 0:
				spr = global.token_rad;
				break;
			case 1:
				spr = global.token_reroll;
				break;
			case 2:
				if("MutationTokenMut" in self){
					if(is_real(MutationTokenMut)){
						draw_sprite_ext(sprSkillIconHUD, MutationTokenMut, bbox_right-1, bbox_top-1+(addy ? 1 : 0), 1, 1, 0, addy ? c_gray : c_white, 1);
					}else if(is_string(MutationTokenMut) && mod_exists("skill", MutationTokenMut)){
						draw_sprite_ext(mod_script_call("skill", MutationTokenMut, "skill_icon"), 0, bbox_right-1, bbox_top-1+(addy ? 1 : 0), 1, 1, 0, addy ? c_gray : c_white, 1);
					}
				}
				spr = global.token_reroll_wepmut;
				break;
			default:
				spr = global.token_rad;
				break;
		}
		draw_sprite_ext(spr, max(tokenIndex, 0), bbox_right-1, bbox_top-1+(addy ? 1 : 0), 1, 1, 0, addy ? c_gray : c_white, 1);
		switch(MutationTokenType){
			case 2:
				break;
			default:
				break;
		}
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

#define rad_effect_step
	image_angle += rot_speed;
	motion_add(point_direction(x, y, 10, 10), 0.9);
	if(distance_to_point(10, 10) < 10){
		instance_destroy(self);
	}
	
//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call