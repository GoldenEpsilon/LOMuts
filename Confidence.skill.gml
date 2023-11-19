#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Confidence.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Confidence Icon.png", 1, 8, 8)

#define skill_name
	return "Confidence";
	
#define skill_text
	return "@wPOWER BOOST @sWHILE AT @rMAX HP";
	
#define stack_text
	return "MORE @wPOWER@s AT MAX HP"

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "I CAN TAKE ON EVERYTHING!";
	
#define skill_type
	return "offensive";
	
#define skill_take
	sound_play(sndMut);
	sound_play_pitch(sndMutant6Cnfm, 1.4);
	wait(5);
	sound_play_pitch(sndMutant6Cnfm, 1.6);
	wait(5);
	sound_play_pitch(sndMutant6Cnfm, 1.2);
	wait(5);
	sound_play_pitch(sndMutant6Cnfm, 1.8);
	wait(5);
	sound_play_pitch(sndMutant6Cnfm, 1.4);
	wait(15);
	sound_play(sndVenuz);
	
	
#define skill_lose
with(Player){
	if(confidence > 0){
		confidence = 0;
		maxspeed -= 0.5 * skill_get(mod_current);
		reloadspeed -= 0.3 * skill_get(mod_current);
	}
}
#define step
with(Player){
	if("confidence" not in self){
		confidence = 0;
	}
	if(my_health >= maxhealth && confidence <= 0){
		confidence = 1;
		maxspeed += 0.5 * skill_get(mod_current);
		reloadspeed += 0.3 * skill_get(mod_current);
	}
	if(my_health < maxhealth && confidence > 0){
		confidence = 0;
		maxspeed -= 0.5 * skill_get(mod_current);
		reloadspeed -= 0.3 * skill_get(mod_current);
	}
}
script_bind_step(custom_step, 0);
#define custom_step
instance_destroy();
with(instances_matching(Player, "confidence", 1)){
	with(instances_matching_ne(instances_matching(projectile, "creator", self), "confidence", 1)){
		confidence = 1;
		speed *= 1 + 0.3 * skill_get(mod_current);
		damage = floor(damage * 1.25);
		image_xscale *= 1.1;
	}
}