#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Recurrent Neural Network";
	
#define skill_text
	return "@gPlasma@w bounces@s";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Boing";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return true;
	
#define step
with(Player){
	with(instances_matching(instances_matching([PlasmaBall, PlasmaBig, PlasmaHuge, CustomObject],"plasmabounce",null),"team",team)){
		plasmabounce = 0;
		if(object_index != CustomObject || "is_plasma" in self && is_plasma){
			plasmabounce = 1 + 1 * skill_get(mod_current);
		}
	}
	with(instances_matching(instances_matching_ge(projectile,"plasmabounce",1),"team",team)){
		if(place_meeting(x + hspeed, y + vspeed, Wall)){
			with instance_create(x, y, PlasmaImpact){team = other.team; creator = other}
			plasmabounce--;
			move_bounce_solid(false)
			image_angle = direction
			speed *= .9
			sleep(5)
			view_shake_at(x, y, 5)
			direction += random_range(-2, 2);
			sound_play_pitch(skill_get(mut_laser_brain) = 1 ? sndPlasmaBigExplode : sndPlasmaBigExplodeUpg, random_range(1.5, 1.7))
			sound_play_pitchvol(sndPlasmaHit, 1, .6)
		}
	}
}