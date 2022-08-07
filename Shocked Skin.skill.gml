#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Shocked Skin.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Shocked Skin Icon.png", 1, 8, 8)
global.sprShellShock = sprite_add("Sprites/ShellShock.png", 3, 12, 12)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call

#define skill_name
	return "Shocked Skin";
	
#define skill_text
	return "@wShells@s burst#on @wImpact@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Shock absorption";
	
#define skill_bodypart return 2
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	
#define update(_id)
	with(Player){
		with(instances_matching_ne(instances_matching_gt(instances_matching([Bullet2, FlameShell, HeavySlug, UltraShell, Slug], "creator", self), "id", _id), "ShockedSkin", true)){
			if(fork()){
				var _x = x + hspeed + lengthdir_x(sprite_width/4, direction);
				var _y = y + vspeed + lengthdir_y(sprite_width/4, direction);
				var _t = team;
				var _oi = object_index;
				var _damage = damage;
				var _xscale = image_xscale;
				var _yscale = image_yscale;
				while(instance_exists(self) && speed > 0){
					_x = x + hspeed + lengthdir_x(sprite_width/4, direction);
					_y = y + vspeed + lengthdir_y(sprite_width/4, direction);
					_t = team;
					wait(0);
				}
				repeat(_damage){
					if(irandom(2) == 0){
						with(instance_create(_x,_y,_oi)){
							ShockedSkin = true;
							direction = random(360);
							speed = 10;
							team = _t;
							damage = 1;
							image_xscale = _xscale / 2;
							image_yscale = _yscale / 2;
						}
					}
				}
				exit;
			}
		}
	}

#define wallHit
return true;

#define merge(curr, prev)
	curr.superforce += prev.superforce;