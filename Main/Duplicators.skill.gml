#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Duplicators.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Duplicators Icon.png", 1, 8, 8)
global.modifier = 2;

#define skill_name
	return "Duplicators";
	
#define skill_text
	return "@wRECOVER @sSOME SPENT @yAMMO#@sAFTER A DELAY";
	
#define stack_text
	return "@wRECOVER @sMORE SPENT @yAMMO#@sAFTER A DELAY";

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
	if("dupAmmoTimer" not in self){
		dupAmmoTimer = current_frame;
	}
	if("dupAmmoStored" not in self){
		dupAmmoStored = [];
		for(var i = 0; i < array_length(ammo); i++){
			array_push(dupAmmoStored, 0);
		}
	}
	OldAmmo = [];
	for(var i = 0; i < array_length(ammo); i++){
		array_push(OldAmmo, real(ammo[i]));
	}

	if("dupAmmoRemainder" not in self){
		dupAmmoRemainder = [];
		for(var i = 0; i < array_length(ammo); i++){
			array_push(dupAmmoRemainder, 0);
		}
	}

	if(current_frame - dupAmmoTimer > 30) {
		for(var i = 0; i < array_length(dupAmmoStored); i++){
			if(dupAmmoStored[i] > current_time_scale){
				dupAmmoStored[i] -= current_time_scale;
				dupAmmoRemainder[i] += current_time_scale;
				while(dupAmmoRemainder[i] >= 1){
					dupAmmoRemainder[i]--;
					ammo[i]++;
				}
			}
		}
	}
}
script_bind_step(custom_step, -5);
#define custom_step
with(Player){
	for(var i = 0; i < array_length(ammo); i++){
		if(ammo[i] < OldAmmo[i]){
			dupAmmoTimer = current_frame;
			var val = (OldAmmo[i] - ammo[i])/(global.modifier / skill_get(mod_current))
			dupAmmoStored[i] += val
		}
	}
}
instance_destroy();

#define player_hud(_player, _hudIndex, _hudSide)
draw_set_font(fntSmall);
for(var i = 0; i < array_length(_player.dupAmmoStored); i++){
	if(_player.dupAmmoStored[i] > 0){
		draw_text(i*10 - 20 - max(0, floor(log10(_player.dupAmmoStored[i]))*2.5), 36, floor(_player.dupAmmoStored[i]));
	}
}
draw_set_font(fntM0);