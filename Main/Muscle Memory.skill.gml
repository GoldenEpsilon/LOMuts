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
	return "Reflected bullets @wtarget@s#Reflected bullets are @wpowerful@s";

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
	with(instances_matching_ne(projectile, "orig_team", team)){
		if("orig_team" in self && orig_team != null && instance_exists(self) && object_is_ancestor(object_index, projectile) && instance_exists(enemy) && team == other.team){
			orig_team = null;
			var i = instance_nearest(x,y,enemy);
			direction = point_direction(x,y,i.x,i.y);
			image_angle = direction;
			speed *= 2 + 0.5 * skill_get(mod_current);
			damage += skill_get(mod_current) * 3;
			image_blend = merge_color(image_blend, c_red, 0.35);
			image_xscale *= 1.25;
			image_yscale *= 0.75;
		}
	}	
}

#define update(_id)
with(Player){
	with(instances_matching_ne(projectile, "team", team)){
		orig_team = team;
	}
}