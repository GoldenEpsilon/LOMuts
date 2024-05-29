#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Absorbing Abs.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.absorb = sprite_add("Sprites/absorb.png", 5, 24, 24)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");
global.bolts = [];

#define skill_name
	return "Absorbing Abs";
	
#define skill_text
	return "Bolts @wabsorb@s projectiles#and release them on hit";
	
#define stack_text
	return "Bolts @wabsorb@s from#further away";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_tip
	return "Shlorp";
	
#define skill_type
	return "outcast";
	
#define skill_take
	sound_play(sndMut);
	
#define skill_wepspec
	return 1;

#define step
	for(var i = 0; i < array_length(global.bolts); i++){
		if(!instance_exists(global.bolts[i][@3]) || !object_is_ancestor(global.bolts[i][@3].object_index, projectile)){
			with(global.bolts[i][@4]){
				if(!instance_exists(self)){
					break;
				}
				if(prevObj == undefined){
					instance_destroy();
					break;
				}
				x = global.bolts[i][@0];
				y = global.bolts[i][@1];
				instance_change(prevObj, 0);
				prevObj = null;
				speed = deactivate_speed;
				image_speed = deactivate_image_speed;
				sprite_index = deactivate_sprite_index;
				image_index = deactivate_image_index;
				image_alpha = deactivate_image_alpha;
				abs_absorbed = true;
				image_blend = trail_color;
				if(skill_get(mod_current) > 1){
					repeat(skill_get(mod_current) - 1){
						with(instance_copy(self)){
							team = other.team;
							abs_absorbed = true;
							trail_color = other.trail_color;
							image_blend = trail_color;
							var prevDir = direction;
							direction = global.bolts[i][@2]+180 + random_range(-10, 10);
							image_angle += direction-prevDir;
						}
					}
				}
			}
			global.bolts = call(scr.array_delete, global.bolts, i);
		}else{
			with(global.bolts[i][@3]){
				global.bolts[i][@0] = x;
				global.bolts[i][@1] = y;
				global.bolts[i][@2] = direction;
				with(instances_in_circle(instances_matching_ne(projectile, "team", team), x, y, damage * (1 + skill_get(mod_current))/2)){
					if("team" not in self){
						continue;
					}
					with(instance_create(x, y, ImpactWrists)){sprite_index = global.absorb;}
					team = other.team;
					var prevDir = direction;
					direction = global.bolts[i][@2]+180 + random_range(-60, 60);
					image_angle += direction-prevDir;
					trail_color = (instance_exists(other.creator) && other.creator.team == 2) ? make_color_rgb(255, 200, 24) : (instance_exists(other.creator) && "index" in other.creator ? player_get_color(other.creator.index) : c_white);
					prevObj = object_index;
					deactivate_speed = speed;
					deactivate_image_speed = image_speed;
					deactivate_sprite_index = sprite_index;
					deactivate_image_index = image_index;
					deactivate_image_alpha = image_alpha;
					instance_change(Wind, 0);
					speed = 0;
					image_speed = 0;
					image_index = 1;
					image_alpha = 0;
					array_push(global.bolts[i][@4], self);
				}
			}
		}
	}
	with(instances_matching(projectile, "abs_absorbed", true)){
		scrSuperHot(self, trail_color);
		with(instance_create(x, y, BoltTrail)){
			image_blend = other.trail_color;
			image_xscale = other.speed;
			image_yscale = other.sprite_width / 5;
			image_angle = other.direction;
		}
	}
	
#define update(_id)
	with(Player){
		with(instances_matching(instances_matching(instances_matching_gt(projectile, "id", _id), "team", team), "ammo_type", 3)){
			array_push(global.bolts, [x, y, direction, self, []]);
		}
		with(instances_matching(instances_matching_gt([Bolt, HeavyBolt, Splinter, UltraBolt, Disc, Seeker], "id", _id), "team", team)){
			array_push(global.bolts, [x, y, direction, self, []]);
		}
	}

#macro call script_ref_call
#macro scr global.scr

#define scrSuperHot(_inst, _color)
	with(_inst) if(visible){
		//image_blend = _color;
		if(_color != 0){
			script_bind_draw(reset_visible, depth - 1, id, visible);
			script_bind_draw(superhot_draw, depth, id, _color);
		}
	}

#define superhot_draw(_id, _color)
	d3d_set_fog(1, _color, 0, 0);
	with(_id){
		visible = 0;
		if("right" in self || "rotation" in self) event_perform(ev_draw, 0);
		else draw_self();
		if(object_index == MeleeFake || object_index == JungleAssassinHide) draw_self();
	}
	d3d_set_fog(0, 0, 0, 0);
	instance_destroy();

#define reset_visible(_id, _visible)
	with(_id) visible = _visible;
	instance_destroy();