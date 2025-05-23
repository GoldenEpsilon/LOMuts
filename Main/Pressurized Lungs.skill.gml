#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Pressurized Lungs.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Pressurized Lungs Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#macro scr global.scr
#macro call script_ref_call

#define skill_name
	return "Pressurized Lungs";
	
#define skill_text
	return "@wFLAMES @sKNOCK BACK @wENEMIES";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "It's the terror of knowing#what this world is about";
	
#define skill_type
	return "utility";
	
#define skill_take
	sound_play(sndMut)
	sound_play(sndMutant1Slct)
	wait(8)
	sound_play(sndDragonStop)

#define late_step
var teams = [];
/*with(instances_matching_ne([Flame, TrapFire], "pressurized", true)){
	pressurized = true;
	damage = round(damage/2);
}*/
with(Player){
	array_push(teams, team);
	with(instances_matching(Flame, "creator", self)){
		pressurizedPush();
	}
	with(instances_matching(instances_matching(CustomProjectile, "is_fire", true), "creator", self)){
		pressurizedPush();
	}
}
with(instances_matching(Flame, "creator", -4)){
	if(array_find_index(teams, team) >= 0){
		pressurizedPush();
	}
}
with(instances_matching(instances_matching(CustomProjectile, "is_fire", true), "creator", -4)){
	if(array_find_index(teams, team) >= 0){
		pressurizedPush();
	}
}
with(enemy){
	if("pressurized" not in self){pressurized = 0;}
	pressurized = max(pressurized-1 * current_time_scale, 0);
}

#define pressurizedPush
	var _team = team;
	with(call(scr.instance_rectangle_bbox, bbox_left, bbox_top, bbox_right, bbox_bottom, instances_matching_ne(enemy, "team", team))){
		if("pressurized" not in self){pressurized = 0;}
		pressurized += 2 * current_time_scale;
		if(pressurized > 30){
			with(call(scr.superforce_push, self, 4 + 8 * skill_get(mod_current), other.direction, 0.2, 1, 0.5, 1)){
				hook_step = script_ref_create(pressurized_step);
				hook_wallhit = script_ref_create(pressurized_wall);
				realTeam = _team;
				other.pressurized = -60;
			}
		}else if(speed > 1 && angle_difference(direction, other.direction) > 90){
			speed = max(speed - skill_get(mod_current) * current_time_scale, 1);
		}
	}

#define pressurized_step
	if(floor(superforce) > 0){
		repeat(floor(superforce)){
			if(call(scr.chance_ct, max(skill_get(mod_current), 1), 6)){
				with(instance_create(x,y,Flame)){
					GETweaks = false;
					creator = other;
					team = other.realTeam;
					direction = random(360);
					image_angle = direction;
					speed = skill_get(mod_current)*2;
				}
			}
		}
	}

#define pressurized_wall
	return 1;