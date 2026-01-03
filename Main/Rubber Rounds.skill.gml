#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Rubber Rounds.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Rubber Rounds Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Rubber Rounds";
	
#define skill_text
	return "Enemy shots have a#chance to @wbounce@s#and become @wfriendly@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_tip
	return "Boing";
	
#define skill_type
	return "utility";
	
#define skill_take
	sound_play(sndMut);

#define step
	with(Player){
		with(instances_matching(instances_matching_ne(instances_matching_ne(projectile, "team", 0), "team", team),"rubber",null)){
			if(object_index != TrapFire && object_index != EnemySlash && object_index != EnemyLaser){
				rubber = random_range(0, 1 + skill_get(mod_current)) > 1.5;
				if(rubber){
					rubberowner = other;
					rubbercol = (rubberowner.team == 2) ? make_color_rgb(255, 200, 24) : ("index" in self ? player_get_color(rubberowner.index) : c_white);
				}
			}
		}
	}
	with(instances_matching_ne(projectile, "rubberowner", null)){
		if(instance_exists(rubberowner)){
			if(rubber == 1){
				if(place_meeting(x+hspeed*current_time_scale, y+vspeed*current_time_scale, Wall)){
					image_blend = rubbercol;
					team = rubberowner.team;
					instance_create(x, y, ImpactWrists).image_blend = rubbercol;
					rubber = 0;
					move_bounce_solid(false);
					image_angle = direction;
					sleep(5);
					view_shake_at(x, y, 5);
					direction += random_range(-2, 2);
					sound_play_pitchvol(sndCanBounce2, random_range(0.3, 0.6), 1);
				}
			}else{
				scrOutline(self, rubbercol);
			}
		}
	}

#macro call script_ref_call
#macro scr global.scr

#define scrOutline(_inst, _color)
	with(_inst) if(visible){
		//image_blend = _color;
		if(_color != 0){
			script_bind_draw(outline_draw, depth + 1, id, _color);
		}
	}

#define outline_draw(_id, _color)
	d3d_set_fog(1, _color, 0, 0);
	with(_id){
		image_xscale += 0.2;
		image_yscale += 0.2;
		if("right" in self || "rotation" in self) event_perform(ev_draw, 0);
		else draw_self();
		if(object_index == MeleeFake || object_index == JungleAssassinHide) draw_self();
		image_xscale -= 0.2;
		image_yscale -= 0.2;
	}
	d3d_set_fog(0, 0, 0, 0);
	instance_destroy();