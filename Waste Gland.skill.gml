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
	return "@wExplosions@s are @wtoxic@s#Toxic clouds @wavoid@s you#and move towards @wenemies@s";

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
	if(speed < 3 && distance_to_object(Player) > distance_to_object(enemy)){
		var nearestEnemy = instance_nearest(x,y,enemy);
		if(!(nearestEnemy == -4 ||nearestEnemy.object_index == FrogQueen || nearestEnemy.object_index == SuperFrog || nearestEnemy.object_index == Exploder)){
			var _x = nearestEnemy.x;
			var _y = nearestEnemy.y;
			var d = distance_to_point(nearestEnemy.x, nearestEnemy.y);
			if(nearestEnemy != -4 && d < 100){
				motion_add(point_direction(x, y, _x, _y), 1 * skill_get(mod_current));
			}
		}
	}
	if(instance_exists(Player)){
		if(image_xscale < 0.25 && image_yscale < 0.25){
			damage = 1;
		}
		var dist = distance_to_object(Player);
		if(dist < 100){
			var inst = instance_nearest(x,y,Player);
			var prevSpeed = speed;
			motion_add(point_direction(inst.x,inst.y,x,y), min(100/dist, 0.75) * max(instance_number(ToxicGas)/maxTox, 1) * skill_get(mod_current));
			if(speed < prevSpeed || speed > 3){
				speed *= 0.6 / skill_get(mod_current);
			}
			if(dist + distance_to_object(Wall) < 20 && dist < 20 && distance_to_object(Wall) < 20){
				with(instance_create(x,y,Smoke)){
					sprite_index = other.sprite_index;
					growspeed = -0.01;
					image_xscale = other.image_xscale;
					image_yscale = other.image_yscale;
				}
				instance_destroy();
			}
		}
	}
}