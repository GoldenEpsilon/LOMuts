#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Precision Incision.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Precision Incision Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Precision Incision";
	
#define skill_text
	return "All @wEnergy weapons@s are#@bPseudo-Hitscan@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Pew Pew";
	
#define skill_take
	sound_play(sndMut);
	
#define step
	with(instances_matching(projectile, "PIhitscan", 1)){
		run_hitscan(self);
	}
	
#define update(_id)
	with(Player){
		if(weapon_get_type(wep) == 5){
			with(instances_matching(instances_matching_ne(instances_matching_ne(instances_matching_gt(projectile, "id", _id), "ammo_type", -1), "PIhitscan_check", true), "creator", self)){
				PIhitscan_check = true;
				PIhitscan = 1;
				run_hitscan(self);
			}
		}else{
			with(instances_matching(instances_matching_ne(instances_matching_gt(projectile, "id", _id), "PIhitscan_check", true), "creator", self)){
				PIhitscan_check = true;
				if(ammo_type == 5){
					PIhitscan = 1;
					run_hitscan(self);
				}else{
					PIhitscan = 0;
				}
			}
		}
	}

#define run_hitscan(_proj)
with(creator){
	with(_proj){
		var size = 0.8;
		repeat(5 * skill_get(mod_current)){
			if(!instance_exists(self)){continue;}
			event_perform(ev_step, ev_step_begin);
			if(!instance_exists(self)){continue;}
			event_perform(ev_step, ev_step_normal);
			if(!instance_exists(self)){continue;}
			for(var i = 0; i < 4; i++){//alarms for projectiles don't go past 3
				if(alarm_get(i) > 0){
					alarm_set(i, alarm_get(i) - current_time_scale);
					if(alarm_get(i) <= 0){
						event_perform(ev_alarm, i);
					}
				}
			}
			with(instance_create(x,y,Effect)){
				sprite_index = other.sprite_index;
				image_index = other.image_index;
				image_speed = 0;
				image_xscale = other.image_xscale * size;
				image_yscale = other.image_yscale * size;
				image_alpha = other.image_alpha * size;
				image_angle = other.image_angle;
				if(fork()){
					if(instance_exists(self)){
						image_xscale *= 0.8;
						image_yscale *= 0.8;
						image_alpha *= 0.8;
					}
					wait(1);
					if(instance_exists(self)){
						image_xscale *= 0.8;
						image_yscale *= 0.8;
						image_alpha *= 0.8;
					}
					wait(1);
					if(instance_exists(self)){
						image_xscale *= 0.8;
						image_yscale *= 0.8;
						image_alpha *= 0.8;
					}
					wait(1);
					if(instance_exists(self)){
						instance_destroy();
					}
					exit;
				}
			}
			xprevious = x;
			yprevious = y;
			x += hspeed_raw;
			y += vspeed_raw;
			var _inst = call(scr.instances_meeting, x, y, [projectile, hitme, Wall]);
			with(_inst){
				if(!instance_exists(_proj)){continue;}
				if("nexthurt" in self){nexthurt -= current_time_scale;}
				with(_proj){
					event_perform(ev_collision, other.object_index);
					if(!instance_exists(self)){continue;}
				}
			}
			if(!instance_exists(self)){continue;}
			event_perform(ev_step, ev_step_end);
			if(!instance_exists(self)){continue;}
			image_index += image_speed_raw;
			size += 0.2/5 * skill_get(mod_current)
		}
		if(!instance_exists(self)){continue;}
		with(instance_create(x,y,Effect)){
			sprite_index = other.sprite_index;
			image_index = other.image_index;
			image_speed = 0;
			image_xscale = other.image_xscale * size;
			image_yscale = other.image_yscale * size;
			image_angle = other.image_angle;
			if(fork()){
				if(instance_exists(self)){
					image_xscale *= 0.8;
					image_yscale *= 0.8;
				}
				wait(1);
				if(instance_exists(self)){
					image_xscale *= 0.8;
					image_yscale *= 0.8;
				}
				wait(1);
				if(instance_exists(self)){
					image_xscale *= 0.8;
					image_yscale *= 0.8;
				}
				wait(1);
				if(instance_exists(self)){
					instance_destroy();
				}
				exit;
			}
		}
	}
}

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call