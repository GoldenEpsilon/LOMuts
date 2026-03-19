#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Duplicators.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Duplicators Icon.png", 1, 8, 8)
global.modifier = 3;

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
	if("dupAmmoTimer" not in self){ dupAmmoTimer = current_frame; }
	if("dupAmmoRegenFactor" not in self){ dupAmmoRegenFactor = 0; }
	if("dupAmmoStored" not in self){
		dupAmmoStored = [];
		for(var i = 0; i < array_length(ammo); i++){
			array_push(dupAmmoStored, 0);
		}
	}

	if("dupAmmoRemainder" not in self){
		dupAmmoRemainder = [];
		for(var i = 0; i < array_length(ammo); i++){
			array_push(dupAmmoRemainder, 0);
		}
	}

	if(current_frame - dupAmmoTimer > 30) {
		dupAmmoRegenFactor += 0.001 * current_time_scale;
		for(var i = 0; i < array_length(dupAmmoStored); i++){
			var amount = min(current_time_scale * dupAmmoRegenFactor * typ_ammo[i], dupAmmoStored[i]);
			if(amount > 0){
				dupAmmoStored[i] -= amount;
				dupAmmoRemainder[i] += amount;
				while(dupAmmoRemainder[i] >= 1){
					dupAmmoRemainder[i]--;
					if ammo[i] + 1 < typ_amax[i] {
						ammo[i]++;
						sound_play(sndRecGlandProc)
						instance_create(x + random(20) - 10, y + random(20) - 10, RecycleGland)
					}
				}
			}
		}
	} else {
		dupAmmoRegenFactor = 0;
	}

	OldAmmo = [];
	for(var i = 0; i < array_length(ammo); i++){
		array_push(OldAmmo, real(ammo[i]));
	}
}
script_bind_step(custom_step, -5);
#define custom_step
with(Player){
	for(var i = 0; i < array_length(ammo); i++){
		if(ammo[i] < OldAmmo[i]){
			dupAmmoTimer = current_frame;
			var val = (OldAmmo[i] - ammo[i])/(global.modifier / skill_get(mod_current))
			if dupAmmoStored[i] + val < typ_amax[i] {
				dupAmmoStored[i] += val
			}
		}
	}
}
instance_destroy();

#define player_hud(_player, _hudIndex, _hudSide)
if("dupAmmoTimer" in _player){
	draw_set_font(fntSmall);
	for(var i = 0; i < array_length(_player.dupAmmoStored); i++){
		if(_player.dupAmmoStored[i] >= 1){
			var num = floor(_player.dupAmmoStored[i] + _player.dupAmmoRemainder[i]);
			var offset = 1 * (_player.dupAmmoTimer >= current_frame - current_time_scale)
			draw_text(i*10 - 4 - max(0, floor(log10(num))*2), 45 + offset, num);
		}
	}
	draw_set_font(fntM0);
}