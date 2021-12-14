#define init
global.sprSkillIcon = sprite_add("Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Alchemic Stomach";
	
#define skill_text
	return "Firing while out of ammo#@yconverts@s ammo";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Strange brew";
	
#define skill_take
	sound_play(sndMut);
	
#define step
	//took some code from Brass Blood from minimod here
	with(Player){
		if(button_pressed(index, "fire") && canfire && can_shoot && visible){
			if(array_length(ammo) > 2 && (weapon_get_cost(wep) > ammo[weapon_get_type(wep)] || ammo[weapon_get_type(wep)] <= 0)){
				for(var i = 0; i < 32 && (weapon_get_cost(wep)*2 > ammo[weapon_get_type(wep)] || ammo[weapon_get_type(wep)] <= 0); i++){
					var type = irandom_range(1, array_length(ammo) - 1);
					while(type == weapon_get_type(wep)){
						type = irandom_range(1, array_length(ammo) - 1);
					}
					if(ammo[type] > 0){
						var amnt = floor((min(min(ammo[type], ceil(typ_amax[type]/10)), (weapon_get_cost(wep)*2 - ammo[weapon_get_type(wep)])*typ_amax[type])/typ_amax[type])*typ_amax[weapon_get_type(wep)]);
						ammo[type] -= ceil((amnt/typ_amax[weapon_get_type(wep)])*typ_amax[type]);
						ammo[weapon_get_type(wep)] += amnt * (skill_get(mod_current))/2;
					}
				}
			}
		}
		if(race == "steroids" && button_pressed(index, "spec") && canfire && bcan_shoot && visible){
			if(array_length(ammo) > 2 && (weapon_get_cost(bwep) > ammo[weapon_get_type(bwep)] || ammo[weapon_get_type(bwep)] <= 0)){
				for(var i = 0; i < 32 && (weapon_get_cost(bwep)*2 > ammo[weapon_get_type(bwep)] || ammo[weapon_get_type(bwep)] <= 0); i++){
					var type = irandom_range(1, array_length(ammo) - 1);
					while(type == weapon_get_type(bwep)){
						type = irandom_range(1, array_length(ammo) - 1);
					}
					if(ammo[type] > 0){
						var amnt = min(min(ammo[type], 5), weapon_get_cost(bwep)*2 - ammo[weapon_get_type(bwep)]);
						ammo[type] -= amnt;
						ammo[weapon_get_type(bwep)] += amnt * (skill_get(mod_current))/2;
					}
				}
			}
		}
	}