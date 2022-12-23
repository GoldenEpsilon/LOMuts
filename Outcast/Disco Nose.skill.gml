#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
global.sprDiscoLaser = sprite_add("../Sprites/DiscoLaser.png", 14, 2, 3)

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
			var ang = random(360);
			sound_play(sndLaser);
			for(var i = 0; i < 360; i += 360 / ((sprite_width * image_xscale / 8) * skill_get(mod_current))){
				with instance_create(x,y,EnemyLaser){
					alarm0 = 1;
					direction = other.direction + i + ang;
					image_angle = other.direction + i + ang;
					hitid = [sprite_index, "THE DISCO"];
					team = other.team;
					creator = other;
					sprite_index = global.sprDiscoLaser;
					image_index = irandom(image_number);
				}
			}
		}
		exit;
	}
}