#define init
global.sprSkillIcon = sprite_add("../Sprites/Main/Alchemic Stomach.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Icons/Alchemic Stomach Icon.png", 1, 8, 8)
global.alchemize = sprite_add("../Sprites/AlchemicStomach.png", 7, 8, 8)

#define skill_name
	return "Fusion Gut";
	
#define skill_text
	return "@wFIRING @sWHEN OUT OF @yENERGY#@wCONVERTS @yAMMO";
	
#define stack_text
	return "@yAMMO@s CONVERSION IS MORE EFFICIENT";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "Strange brew";
	
#define skill_type
	return "ammo";
	
#define skill_take
	sound_play(sndMut);
	
#define step
	//took some code from Brass Blood from minimod here
	with(Player){
		if(button_pressed(index, "fire") && canfire && can_shoot && visible){
			var desired_amount = weapon_get_cost(wep)*2*max(1, 30/max(weapon_get_load(wep),1));
			if(array_length(ammo) > 2 && weapon_get_type(wep) == 5 && (weapon_get_cost(wep) > ammo[weapon_get_type(wep)] || ammo[weapon_get_type(wep)] <= 0)){
				var alchemized = false;
				for(var i = 0; i < 32 && (desired_amount > ammo[weapon_get_type(wep)] || ammo[weapon_get_type(wep)] <= 0); i++){
					var type = irandom_range(1, array_length(ammo) - 1);
					while(type == weapon_get_type(wep)){
						type = irandom_range(1, array_length(ammo) - 1);
					}
					if(ammo[type] > 0){
						alchemized = true;
						var amnt = floor((min(min(ammo[type], ceil(typ_amax[type]/10)), (desired_amount - ammo[weapon_get_type(wep)])*typ_amax[type])/typ_amax[type])*typ_amax[weapon_get_type(wep)]);
						ammo[type] -= ceil((amnt/typ_amax[weapon_get_type(wep)])*typ_amax[type]);
						ammo[weapon_get_type(wep)] += ceil(amnt * (skill_get(mod_current))/2);
					}
				}
				if(alchemized){
					with(instance_create(x,y,Effect)){
						sprite_index = global.alchemize;
						image_speed = 0.4;
						depth = -4;
						if(fork()){
							wait(4);
							while(image_index > current_time_scale){
								wait(0);
							}
							instance_destroy();
							exit;
						}
					}
				}
			}
		}
		if(race == "steroids" && button_pressed(index, "spec") && canfire && bcan_shoot && visible){
			var desired_amount = weapon_get_cost(bwep)*2*max(1, 30/max(weapon_get_load(wep),1));
			if(array_length(ammo) > 2 && weapon_get_type(bwep) == 5 && (weapon_get_cost(bwep) > ammo[weapon_get_type(bwep)] || ammo[weapon_get_type(bwep)] <= 0)){
				var alchemized = false;
				for(var i = 0; i < 32 && (desired_amount > ammo[weapon_get_type(bwep)] || ammo[weapon_get_type(bwep)] <= 0); i++){
					var type = irandom_range(1, array_length(ammo) - 1);
					while(type == weapon_get_type(bwep)){
						type = irandom_range(1, array_length(ammo) - 1);
					}
					if(ammo[type] > 0){
						alchemized = true;
						var amnt = floor((min(min(ammo[type], ceil(typ_amax[type]/10)), (desired_amount - ammo[weapon_get_type(bwep)])*typ_amax[type])/typ_amax[type])*typ_amax[weapon_get_type(bwep)]);
						ammo[type] -= amnt;
						ammo[weapon_get_type(bwep)] += ceil(amnt * (skill_get(mod_current))/2);
					}
				}
				if(alchemized){
					with(instance_create(x,y,Effect)){
						sprite_index = global.alchemize;
						image_speed = 0.4;
						depth = -4;
						if(fork()){
							wait(4);
							while(image_index > current_time_scale){
								wait(0);
							}
							instance_destroy();
							exit;
						}
					}
				}
			}
		}
	}