#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Duplicators.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Duplicators Icon.png", 1, 8, 8)
global.modifier = 3;

#define skill_name
	return "Duplicators";
	
#define skill_text
	return "@wRECOVER @sSOME SPENT @yAMMO @sWHEN FIRING";
	
#define stack_text
	return "@wRECOVER @sMORE SPENT @yAMMO @sWHEN FIRING";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "You don't want to know how it works.";
	
#define skill_type
	return "ammo";
	
#define skill_take
	sound_play(sndMutEagleEyes);
	
#define step

with(Player){
	OldAmmo = [];
	for(var i = 0; i < array_length(ammo); i++){
		array_push(OldAmmo, real(ammo[i]));
	}
}
script_bind_step(custom_step, -5);
#define custom_step
with(Player){
	if("dupAmmoRemainder" not in self){
		dupAmmoRemainder = [];
		for(var i = 0; i < array_length(ammo); i++){
			array_push(dupAmmoRemainder, 0);
		}
	}
	for(var i = 0; i < array_length(ammo); i++){
		if(ammo[i] < OldAmmo[i]){
			var val = (ammo[i]*((global.modifier / skill_get(mod_current))-1) + OldAmmo[i])/(global.modifier / skill_get(mod_current)) + dupAmmoRemainder[i]
			ammo[i] = floor(val);
			dupAmmoRemainder[i] = val - floor(val);
		}
	}
}
instance_destroy();