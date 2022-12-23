#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");
global.bolts = [];

#define skill_name
	return "Absorbing Abs";
	
#define skill_text
	return "Bolts @wabsorb@s projectiles#and release them on hit";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Shlorp";
	
#define skill_take
	sound_play(sndMut);

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
				image_xscale = deactivate_image_xscale;
				image_yscale = deactivate_image_yscale;
				if(fork()){
					wait(0);
					abs_absorbed = true;
					team = absorb_team;
					if(skill_get(mod_current) > 1){
						repeat(skill_get(mod_current) - 1){
							with(instance_copy(self)){
								var prevDir = direction;
								direction = global.bolts[i][@2]+180 + random_range(-10, 10);
								image_angle += direction-prevDir;
							}
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
				with(call(scr.instances_meeting, x, y, instances_matching_ne(projectile, "team", team))){
					if("team" not in self){
						continue;
					}
					with(instance_create(x, y, ImpactWrists)){}
					absorb_team = other.team;
					var prevDir = direction;
					direction = global.bolts[i][@2]+180 + random_range(-10, 10);
					image_angle += direction-prevDir;
					trail_color = (instance_exists(other.creator) && "index" in other.creator) ? player_get_color(other.creator.index) : c_white
					prevObj = object_index;
					deactivate_speed = speed;
					deactivate_image_speed = image_speed;
					deactivate_sprite_index = sprite_index;
					deactivate_image_index = image_index;
					deactivate_image_alpha = image_alpha;
					deactivate_image_xscale = image_xscale;
					deactivate_image_yscale = image_yscale;
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
		with(instances_matching(instances_matching_gt([Bolt, HeavyBolt, UltraBolt, Disc, Seeker], "id", _id), "team", team)){
			array_push(global.bolts, [x, y, direction, self, []]);
		}
	}

#macro call script_ref_call
#macro scr global.scr