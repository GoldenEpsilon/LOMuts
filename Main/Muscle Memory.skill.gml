#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Muscle Memory.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Muscle Memory Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#macro call script_ref_call
#macro scr global.scr

#define skill_name
	return "Muscle Memory";
	
#define skill_text
	return "Reflected bullets are @wpowerful@s and @wtarget@s#Enemy shots can @wbounce@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return choose("Reflexes", "Reflected bullets#are now faster!", "Reflected bullets#deal more damage!");
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMut);
	sound_play(sndMutant7Slct);
	wait(18);
	sound_play_pitch(sndMutant7Hurt, 0.9);
	sound_play(sndWrench);
	wait(12);
	sound_play_pitch(sndMutant7Hurt, 0.9);
	sound_play(sndWrench);
	wait(12);
	sound_play_pitch(sndMutant7Hurt, 0.9);
	sound_play(sndWrench);
	
#define step
with(Player){
	with(instances_matching(instances_matching_ne(instances_matching_ne(projectile, "team", 0), "team", team),"rubber",null)){
		if(object_index != TrapFire && object_index != EnemySlash && object_index != EnemyLaser){
			rubber = random_range(0, 1 + skill_get(mod_current)) > 1;
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
				// sleep(5);
				// view_shake_at(x, y, 5);
				direction += random_range(-2, 2);
				sound_play_pitchvol(sndCanBounce2, random_range(0.3, 0.6), 1);
			}
		}else{
			scrOutline(self, rubbercol);
		}
	}
}
with(Player){
	with(instances_matching_ne(projectile, "orig_team", team)){
		if("orig_team" in self && orig_team != null && instance_exists(self) && object_is_ancestor(object_index, projectile) && instance_exists(enemy) && team == other.team){
			orig_team = null;
			var i = instance_nearest(x,y,enemy);
			direction = point_direction(x,y,i.x,i.y);
			image_angle = direction;
			speed *= 2 + 0.5 * skill_get(mod_current);
			damage += skill_get(mod_current) * 9;
			image_blend = merge_color(image_blend, c_red, 0.35);
			image_xscale *= 1.25;
			image_yscale *= 0.75;
			sleep(5);
			view_shake_at(x, y, 3);
		}
	}	
}

#define update(_id)
with(Player){
	with(instances_matching_ne(projectile, "team", team)){
		orig_team = team;
	}
}

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