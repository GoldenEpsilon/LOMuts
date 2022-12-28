#define init
global.sprSkillIcon = sprite_add("../Sprites/Blights/Angry Eyebrows.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Blights/Angry Eyebrows Icon.png", 1, 8, 8)

#define skill_name
	return "Angry Eyebrows";
	
#define skill_text
	return "Enemies shoot @wREVENGE BULLETS@s#randomly on death";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "TouNou...";

#define skill_avail
	return false;

#define skill_blight
	return true;
	
#define skill_take
	sound_play(sndMut);
	
#define step
if(instance_exists(Player)){
	with instances_matching_le(enemy, "my_health", 0) {
		var amount = irandom(sqrt(maxhealth));
		if(amount > 0){
			repeat(amount){
				with(instance_create(x,y,EnemyBullet2)){
					speed = 6;
					team = other.team;
					creator = other;
					direction = point_direction(x, y, instance_nearest(x,y,Player).x, instance_nearest(x,y,Player).y) + random_range(amount*-5,amount*5);
					image_angle = direction;
				}
			}
		}
	}
}