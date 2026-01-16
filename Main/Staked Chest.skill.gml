#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Staked Chest.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Staked Chest Icon.png", 1, 8, 8)

#define skill_name
	return "Staked Chest";
	
#define skill_text
	return "@wPIERCING BOLTS @sCREATE @wSPLINTERS";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "These things hurt";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMutTriggerFingers)

#define skill_chest_type
	return 3;
	
#define step

with(instances_matching_le(enemy, "my_health", 0)){
	var list = [Bolt, HeavyBolt, ToxicBolt, UltraBolt, Disc, Seeker, CustomProjectile];
	var temp = -4;
	for(var i = 0; i < array_length(list); i++){
		temp = instance_nearest(x,y,list[i]);
		if(temp >= 0 && distance_to_object(list[i]) < sqrt(sqr((sprite_width*image_xscale)/2)+sqr((sprite_height*image_yscale)/2))){
			with(temp){
				if((object_index == CustomProjectile || object_index == CustomSlash) && ("ammo_type" not in self || ammo_type != 3)){
					continue;
				}
				var rotations = (360 / damage) * 2;
				for(var i = rotations/2; i < 360 + rotations/2; i += rotations / skill_get(mod_current)){
					if(speed > 0){
						with(instance_create(x,y,Splinter)){
							direction = other.direction + i;
							image_angle = direction;
							speed = 12;
							team = other.team;
							creator = other.creator;
						}
					}
				}
			}
		}
	}
}