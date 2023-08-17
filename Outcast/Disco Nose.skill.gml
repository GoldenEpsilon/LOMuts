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
	
#define skill_type
	return "outcast";
	
#define skill_take
	sound_play(sndMut);

#define step
with(instances_matching(Explosion, "laserdisco", null)){
	laserdisco = 1;
	if(fork()){
		wait(3)
		if(instance_exists(self)){
			if("creator" in self && instance_exists(creator) && "team" in creator){
				team = creator.team;
			}else if(("team" not in self || team <= 0) && instance_exists(Player)){
				team = instance_nearest(x,y,Player).team;
			}
			var ang = random(360);
			sound_play(sndLaser);
			var baseAmount = (sprite_width * image_xscale / 16) * skill_get(mod_current);
			var amount = random_range(baseAmount - 2, baseAmount + 1)
			if(amount > 0){
				for(var i = 0; i < 360; i += 360 / amount){
					with instance_create(x,y,Laser){
						direction = other.direction + i + ang;
						image_angle = other.direction + i + ang;
						hitid = [sprite_index, "THE DISCO"];
						team = other.team;
						creator = other;
						sprite_index = global.sprDiscoLaser;
						image_index = irandom(image_number);
						event_perform(ev_alarm, 0)
						x -= lengthdir_x(max(0, image_xscale-40), direction) * 2;
						y -= lengthdir_y(max(0, image_xscale-40), direction) * 2;
						image_xscale = min(image_xscale, 40);
						x += lengthdir_x(other.sprite_width, direction)/12;
						y += lengthdir_y(other.sprite_width, direction)/12;
						image_xscale = max(image_xscale - other.sprite_width/6, 1);
						damage = 2;
						alarm0 = -1;
					}
				}
			}
		}
		exit;
	}
}