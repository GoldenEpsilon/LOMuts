#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Sadism.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Sadism Icon.png", 1, 8, 8)

#define skill_name
	return "Sadism";
	
#define skill_text
	return "Using ammo @rheals@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Yummy casings";
	
#define skill_take
	sound_play(sndMut);
	sound_play(sndMutant5Slct);
	wait(15);
	sound_play(sndPistol);
	wait(5);
	sound_play(sndPistol);
	wait(5);
	sound_play(sndPistol);
	wait(5);
	sound_play(sndBloodlustProc);
	
#define step
with(Player){
	if("sadism" not in self){
		sadism = 0;
		sadismOldAmmo = ammo;
	}
	for(var i = 1; i < array_length(ammo); i++){
		if(ammo[i] < sadismOldAmmo[i]){
			sadism += (sadismOldAmmo[i] - ammo[i]) / (i == 1 ? 5 : 1);
		}
	}
	if(sadism >= 30 / skill_get(mod_current)){
		my_health = min(my_health + 2, maxhealth);
		sadism -= 30 / skill_get(mod_current);
		instance_create(x,y-30,BloodLust).image_yscale = -1;
	}
}
with(Player){
	sadismOldAmmo = [];
	for(var i = 0; i < array_length(ammo); i++){
		array_push(sadismOldAmmo, real(ammo[i]));
	}
}