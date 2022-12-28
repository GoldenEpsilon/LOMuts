#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Waste Gland.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Waste Gland Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#macro scr global.scr
#macro call script_ref_call

#define skill_name
	return "Waste Gland";
	
#define skill_text
	return "@wExplosions@s are @gtoxic@s#@gToxic Gas@s is @wSmart@s#@gToxic @wImmunity@s";

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
	with(Player){
		prevnotoxic = 0;
		if(notoxic){
			prevnotoxic = 1;
		}
		notoxic = 1;
	}
	
#define skill_lose
	with(Player){
		notoxic = prevnotoxic;
	}
	
#define late_step

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
			with(instance_create(_x + irandom(8) - 4,_y + irandom(8) - 4,ToxicGas)){
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
	var nearestEnemy = instance_nearest(x,y,enemy);
	if(!(nearestEnemy == -4 ||nearestEnemy.object_index == FrogQueen || nearestEnemy.object_index == SuperFrog || nearestEnemy.object_index == Exploder) && distance_to_object(enemy) < 200){
		motion_add(point_direction(x, y, nearestEnemy.x, nearestEnemy.y), 0.5 * max(instance_number(ToxicGas)/maxTox, 1) * skill_get(mod_current));
		x+=1000;
		nearestTox = instance_nearest(x-1000,y,ToxicGas);
		x-=1000;
		motion_add(point_direction(nearestTox.x, nearestTox.y, x, y), 0.25 * max(instance_number(ToxicGas)/maxTox, 1) * skill_get(mod_current));
	}
	speed = min(speed, power(image_xscale, 1.5)*6);
	if(instance_exists(Player)){
		if(image_xscale < 0.25 && image_yscale < 0.25){
			damage = 1;
		}
		var dist = distance_to_object(Player);
		if(dist < 100){
			var inst = instance_nearest(x,y,Player);
			var prevSpeed = speed;
			motion_add(point_direction(inst.x,inst.y,x,y), min(15/dist, 0.75) * max(instance_number(ToxicGas)/maxTox, 1) * (inst.maxspeed/4) * skill_get(mod_current));
			if(speed > 3){
				speed = max(prevSpeed, speed * 0.8);
			}
		}
	}
}