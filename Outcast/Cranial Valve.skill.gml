#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#macro scr global.scr
#macro call script_ref_call

#define skill_name
	return "Cranial Valve";
	
#define skill_text
	return "Shotguns have#a @wfixed spread@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return false;

#define skill_outcast
	return true;

#define skill_tip
	return "When's NT3";
	
#define skill_take
	sound_play(sndMut);
	
#define update(_id)
	with(Player){
		var shellList = call(scr.instances_in_rectangle, x-12, y-12, x+12, y+12,
				call(scr.array_combine,
				instances_matching(instances_matching_ge([Bullet2, FlameShell, HeavySlug, UltraShell, Slug], "id", _id), "creator", self),
				instances_matching(instances_matching(instances_matching_ge(CustomProjectile, "id", _id), "is_shell", true), "team", team)),
			);
		var _spread = 0;
		var _speed = 0;
		var _num = array_length(shellList);
		with(shellList){
			_spread = max(angle_difference(other.gunangle, direction), _spread);
			_speed += speed;
		}
		_speed /= _num;
		if(_num == 1){
			with(shellList[0]){
				direction = other.gunangle;
				image_angle = direction;
			}
		}else{
			for(var i = 0; i < _num; i++){
				with(shellList[i]){
					direction = other.gunangle-(i*2-(_num-1))*_spread/(_num-1);
					image_angle = direction;
					speed = _speed;
				}
			}
		}
	}