#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Scrap Arms.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Scrap Arms Icon.png", 1, 8, 8)
global.sprScrap = sprite_add("Sprites/ScrapPackage.png", 1, 6, 6)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Scrap Arms";
	
#define skill_text
	return "@wscraps@s @y(+ammo +firerate)@s#drop from enemies#when you have bullet weapons";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return choose("Scrap's useful", "Scraps give some#extra reload");
	
#define skill_take
	sound_play(sndMut)
	sound_play_pitchvol(sndShotReload, 1.4, 2)
	wait(20);
	sound_play(sndPistol)
	wait(4);
	sound_play(sndPistol)
	wait(4);
	sound_play(sndPistol)
	
#define skill_bodypart return 2
	
#define skill_lose
	with(instances_matching(CustomObject, "name", "ScrapArmsPickup")){
		instance_destroy();
	}
	
#define step
with(instances_matching_le(enemy, "my_health", 0)){
	if("ScrapArms" not in self && instance_nearest(x,y,Player) != noone && (irandom(3 / (skill_get(mut_rabbit_paw)+1)) == 0 && (weapon_get_type(instance_nearest(x,y,Player).wep) == 1 || weapon_get_type(instance_nearest(x,y,Player).bwep) == 1))){
		ScrapArms = true;
		with(call(scr.obj_create, x, y, "LibPickup")){
			name = "ScrapArmsPickup";
			sprite_index = global.sprScrap;
			on_open = script_ref_create(ScrapGet)
			alarm0 = 200;
			pickno = 16 * skill_get(mod_current);
		}
	}
}

#define ScrapGet
	sound_play_pitchvol(sndShotReload, 1.4, 2)
	if(fork()){
		other.reloadspeed /= 2;
		wait(25);
		if(instance_exists(other)){
			other.reloadspeed *= 2;
		}
		exit;
	}
	other.breload = max(other.breload - 5 * skill_get(mod_current), 0);
	var amount = ceil((pickno * other.typ_ammo[1]) / 32);
	other.ammo[1] += amount;
	other.ammo[1] = min(other.ammo[1], other.typ_amax[1]);
	var ismax = other.ammo[1] >= other.typ_amax[1];
	with(instance_create(other.x, other.y, PopupText)) {
		if(ismax) mytext = "MAX BULLETS";
		else mytext = "+"+string(amount)+" BULLETS"
	}
	return false;

#define ScrapArmsDraw
draw_self();

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call