#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "DOLLA DOLLA";
#define skill_text    return "ALL @yAMMO@s USAGE#IS HALVED";
#define skill_tip     return "$HALF OFF AMMO!$#$BUY YOURS TODAY$";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "venuz";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
#define skill_mimicry return true;

#define step
with(instances_matching(Player, "race", char_venuz)){
	OldAmmo = [];
	for(var i = 0; i < array_length(ammo); i++){
		array_push(OldAmmo, real(ammo[i]));
	}
}
script_bind_step(custom_step, -5);
#define custom_step
with(instances_matching(Player, "race", char_venuz)){
	if("dupAmmoRemainder" not in self){
		dupAmmoRemainder = [];
		for(var i = 0; i < array_length(ammo); i++){
			array_push(dupAmmoRemainder, 0);
		}
	}
	for(var i = 0; i < array_length(ammo); i++){
		if(ammo[i] < OldAmmo[i]){
			var val = (ammo[i] + OldAmmo[i])/2 + dupAmmoRemainder[i]
			ammo[i] = floor(val);
			dupAmmoRemainder[i] = val - floor(val);
		}
	}
}
instance_destroy();