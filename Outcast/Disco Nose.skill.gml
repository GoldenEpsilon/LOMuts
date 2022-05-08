#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.sprDiscoLaser = sprite_add("../Sprites/DiscoLaser.png", 1, 2, 3)

#define skill_name
	return "Disco Nose";
	
#define skill_text
	return "explosives create#lasers";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_outcast
	return true;

#define skill_tip
	return "Dance 'till you're dead";
	
#define skill_take
	sound_play(sndMut);

#define step
with(instances_matching(Explosion, "laserdisco", null)){
	laserdisco = 1;
	if(fork()){
		wait(3)
		if(instance_exists(self) && "team" in self){
			for(var i = 0; i < 360; i += 60 / skill_get(mod_current)){
				with instance_create(x,y,EnemyLaser){
					alarm0 = 1;
					direction = other.direction + i;
					image_angle = other.direction + i;
					hitid = [sprite_index, "THE DISCO"];
					team = other.team;
					creator = other;
					image_blend = make_color_hsv(random(255), 255, 255);
					sprite_index = global.sprDiscoLaser;
				}
			}
		}
		exit;
	}
}