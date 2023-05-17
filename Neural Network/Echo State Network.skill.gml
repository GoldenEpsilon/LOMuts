#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Echo State Network";
	
#define skill_text
	return "@bELECTRICITY @wARCS @sTOWARDS @wENEMIES";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Gettin' Grounded";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return true;
	
#define step

with(instances_matching_ne(Lightning, "echostate", true)){
	if(instance_exists(self) && object_index == Lightning){
		var enem = instance_nearest(x,y,enemy);
		if(enem != -4 && instance_nearest(enem.x,enem.y, Lightning) == self && distance_to_point(enem.x,enem.y) < 40 * skill_get(mod_current)){
			echostate = true;
			var newID = instance_create(0, 0, DramaCamera);
			with(instance_create(x,y,Lightning)){
				echostate = true;
				creator = other.creator;
				team = other.team;
				direction = point_direction(x,y,enem.x,enem.y);
				image_angle = direction;
				ammo = min(other.ammo + 3 * skill_get(mod_current), 20);
				event_perform(ev_alarm, 0);
			}
			with(instances_matching_ge(Lightning, "id", newID)){
				echostate = true;
			}
		}
	}
}