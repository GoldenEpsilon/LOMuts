#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Sloppy Fingers.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Sloppy Fingers Icon.png", 1, 8, 8)

#define skill_name
	return "Sloppy Fingers";
	
#define skill_text
	return "Faster Reload, Less Accuracy";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_bodypart return 2

#define skill_tip
	return choose("Whoops!", "Not even eyesight fixes sloppiness");
	
#define skill_take
	sound_play(sndMutTriggerFingers);
	if instance_exists(Player) {
		with Player {
			reloadspeed += 0.4;
			accuracy *= 1.5;
		}
	}
	
#define skill_lose
	if instance_exists(Player) {
		with Player {
			reloadspeed -= 0.4;
			accuracy /= 1.5;
		}
	}

#define step
	script_bind_step(sloppy_step, 0);

#define sloppy_step
with(Player){
	with(instances_matching(instances_matching_ne([Slash, GuitarSlash, BloodSlash, EnergySlash, Shank, EnergyShank, SawBurst, EnergyHammerSlash], "Sloppy_Fingers", 1), "team", team)){
		image_angle += (irandom(40)-20)*(other.accuracy)*(skill_get(mut_eagle_eyes) ? 0.5 : 1);
		Sloppy_Fingers=1;
	}
	with(instances_matching(instances_matching_ne(projectile, "Sloppy_Fingers", 1), "team", team)){
		var r = (irandom(20)-10)*(other.accuracy)*(skill_get(mut_eagle_eyes) ? 0.1 : 1);
		if(object_index != Laser){
			image_angle += r;
			direction += r;
			Sloppy_Fingers=1;
		}else{
			x -= lengthdir_x(image_xscale*2,direction);
			y -= lengthdir_y(image_xscale*2,direction);
			direction += r;
			image_angle += r;
			event_perform(ev_alarm, 0);
			Sloppy_Fingers=1;
		}
	}
}
instance_destroy();