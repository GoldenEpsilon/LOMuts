#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.sprDiscoLaser = sprite_add("../Sprites/DiscoLaser.png", 1, 2, 3)

#define skill_name
	return "Explosive Ears";
	
#define skill_text
	return "Cluster explosions";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_outcast
	return true;

#define skill_tip
	return "Like firecrackers";
	
#define skill_type
	return "outcast";
	
#define skill_take
	sound_play(sndMut);

#define step
with(instances_matching(Explosion, "explosiveearscluster", null)){
	explosiveearscluster = 1;
	if(object_index == Explosion){
		repeat(skill_get(mod_current) * 5){
			if(fork()){
				var _image_speed = image_speed;
				var _image_alpha = image_alpha;
				var _x = x;
				var _y = y;
				while(true){
					wait(0)
					if(!instance_exists(self) || image_index > 8 || irandom(7) == 0){
						with instance_create(_x,_y,SmallExplosion) {
							explosiveearscluster = 1;
							var dir = random(360);
							var len = sqrt(random_range(0.25, 1)) * sprite_width / 3 * image_xscale;
							x = _x + lengthdir_x(len, dir);
							y = _y + lengthdir_y(len, dir);
							if(random(2) < 1){
								laserdisco = null;
							}
							explosiveearscluster = 1;
							image_speed = _image_speed;
							image_index = 0;
							image_alpha = _image_alpha;
						}
						exit;
					}
				}
			}
		}
	}
}