#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Waste Gland.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Waste Gland Icon.png", 1, 8, 8)

#define skill_name
	return "Waste Gland";
	
#define skill_text
	return "@wExplosions@s are @wtoxic@s#Toxic clouds @wavoid@s you";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Let's Waste them all";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	
#define skill_bodypart return 2
	
#define step

with(PopoExplosion){
	if("WasteGland" not in self){WasteGland = 1;}
}
with(SmallExplosion){
	if("WasteGland" not in self){
		WasteGland = 1;
		var _x = x;
		var _y = y;
		if(fork()){
			wait(3);
			with(instance_create(_x + irandom(16) - 8,_y + irandom(16) - 8,ToxicGas)){
				speed/=2;
			}
			exit;
		}
	}
}
with(Explosion){
	if("WasteGland" not in self){
		WasteGland = 1;
		var _x = x;
		var _y = y;
		if(fork()){
			wait(3);
			repeat(6){
				with(instance_create(_x + irandom(16) - 8,_y + irandom(16) - 8,ToxicGas)){
					speed /= 2;
				}
				wait(1);
			}
			exit;
		}
	}
}

var list = [];
var maxTox = 100;
repeat(min(maxTox, instance_number(ToxicGas))){
	array_push(list, irandom(instance_number(ToxicGas)));
}
array_sort(list, true);
var i = -1;
var i2 = 0;
with(ToxicGas){
	i++;
	if(i == list[i2]){
		while(i == list[i2] && i2 + 1 < array_length(list)){
			i2++;
		}
	}else{
		continue;
	}
	if(instance_exists(Player)){
		if(image_xscale < 0.25 && image_yscale < 0.25){
			damage = 1;
		}
		var dist = distance_to_object(Player);
		if(dist < 100){
			var inst = instance_nearest(x,y,Player);
			var prevSpeed = speed;
			motion_add(point_direction(inst.x,inst.y,x,y), min(50/dist, 0.15) * max(instance_number(ToxicGas)/maxTox, 1) * skill_get(mod_current));
			if(speed < prevSpeed || speed > 3){
				speed *= 0.6 / skill_get(mod_current);
			}
		}
	}
}
