#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Fractured Fingers.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Fractured Fingers Icon.png", 1, 8, 8)

#define skill_name
	return "Fractured Fingers";
	
#define skill_text
	return "MELEE SWINGS @wFRACTURE@s#ON HIT";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Explosion babies";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMut)
	sound_play(sndMutant3Slct)
	wait(14)
	sound_play_pitch(sndMutant4Slct, 1.3)
	sound_play(sndMeleeWall)
	wait(2)
	sound_play(sndScrewdriver)
	
#define step
script_bind_step(custom_step, 0);
#define custom_step

with(Player){
	with(instances_matching([Slash, CustomSlash, GuitarSlash, EnergySlash, LightningSlash, Shank, EnergyShank], "team", team)){
		if("FracturedFingers" not in self || FracturedFingers < 4 * skill_get(mod_current)){
			if("FracturedFingers" not in self){
				FracturedFingers = 1;
			}
			var dir = direction;
			var _team = team;
			var list = ds_list_create();
			var ff = FracturedFingers;
			instance_place_list(x, y, enemy, list, false);
			with(ds_list_to_array(list)){
				with(self){
					if(("FracturedFingersCooldown" not in self || FracturedFingersCooldown + 20 < current_frame) && team != _team){
						FracturedFingersCooldown = current_frame;
						var nearest = instance_nearest_nonself(x + lengthdir_x(30, dir), y + lengthdir_y(30, dir), enemy);
						if(instance_exists(nearest)){
							var nearestdir = point_direction(x,y,nearest.x,nearest.y);
							with(instance_create(x + lengthdir_x(5, nearestdir), y + lengthdir_y(5, nearestdir), Shank)){
								FracturedFingers = ff + 1;

								image_speed = 0.2;
								direction = nearestdir;
								image_angle = nearestdir;
								speed = 8;
								team = _team;
							}
						}
					}
				}
			}
			ds_list_destroy(list);
		}
	}
}
instance_destroy();