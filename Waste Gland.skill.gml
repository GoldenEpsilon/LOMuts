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
	return "@wExplosive@s projectiles are @gToxic@s#@gToxic @wImmunity@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Let's Waste them all";
	
#define skill_type
	return "offensive";
	
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
			repeat(skill_get(mod_current)){
				with(instance_create(_x + irandom(8) - 4,_y + irandom(8) - 4,ToxicGas)){
					speed/=2;
					GETweaked = true;
				}
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
			repeat(3+3*skill_get(mod_current)){
				with(instance_create(_x + irandom(16) - 8,_y + irandom(16) - 8,ToxicGas)){
					speed /= 2;
					GETweaked = true;
				}
				wait(1);
			}
			exit;
		}
	}
}