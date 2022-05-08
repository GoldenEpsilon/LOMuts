#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.sprDiscoLaser = sprite_add("../Sprites/DiscoLaser.png", 1, 2, 3)

#define skill_name
	return "Explosive Ears";
	
#define skill_text
	return "explosions explode#twice";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_outcast
	return true;

#define skill_tip
	return "'Splode one get one free!";
	
#define skill_take
	sound_play(sndMut);

#define step
with(instances_matching(Explosion, "explosiveearsdoubled", null)){
	explosiveearsdoubled = 1;
	if(fork()){
		var _repeat = instance_copy(self);
		with(_repeat){
			instance_change(Wind, 0);
			speed = 0;
			image_speed = 0;
			image_index = 1;
			image_alpha = 0;
		}
		while(true){
			var _object_index = object_index;
			var _image_speed = image_speed;
			var _image_alpha = image_alpha;
			wait(0)
			if(!instance_exists(self) || image_index > 4){
				with _repeat {
					instance_change(_object_index, 1);
					explosiveearsdoubled = 1;
					image_speed = _image_speed;
					image_index = 0;
					image_alpha = _image_alpha;
				}
				exit;
			}
		}
	}
}