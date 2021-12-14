#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Scrap Arms.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Scrap Arms Icon.png", 1, 8, 8)
global.sprScrap = sprite_add("Sprites/ScrapPackage.png", 1, 4, 5)

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
	if("ScrapArms" not in self && instance_nearest(x,y,Player) != noone && (irandom(4 / (skill_get(mut_rabbit_paw)+1)) == 0 && (weapon_get_type(instance_nearest(x,y,Player).wep) == 1 || weapon_get_type(instance_nearest(x,y,Player).bwep) == 1))){
		ScrapArms = true;
		with(instance_create(x,y,CustomObject)){
			name = "ScrapArmsPickup";
			sprite_index = global.sprScrap;
			timer = 200;
			on_draw = ScrapArmsDraw;
		}
	}
}
with(instances_matching(CustomObject, "name", "ScrapArmsPickup")){
	if(image_index == 0){image_speed = 0;}
	if(instance_nearest(x,y,Player) != noone){
		var dist = distance_to_object(Player);
		var near = instance_nearest(x,y,Player);
		var pickno = 16 * skill_get(mod_current) + skill_get("magazinefingers")*6;
		if(dist < 25 * (1+skill_get(mut_plutonium_hunger)) || instance_exists(Portal)){
			move_towards_point(near.x, near.y + near.sprite_height/2, 6);
		}
		if(dist < 5 && "grabbed" not in self){
			sound_play_pitchvol(sndShotReload, 1.4, 2)
			if(fork()){
				near.reloadspeed += 0.2;
				wait(25);
				if(instance_exists(near)){
					near.reloadspeed -= 0.2;
				}
				exit;
			}
			near.breload = max(near.breload - 5, 0);
			near.ammo[1] += pickno;
			near.ammo[1] = min(near.ammo[1], near.typ_amax[1]);
			with(instance_create(near.x, near.y, PopupText)) {
				if(near.ammo[1] >= near.typ_amax[1]) mytext = "MAX BULLETS";
				else mytext = "+"+string(pickno)+" BULLETS"
			}
			grabbed = true;
			instance_destroy();
			continue;
		}
	}
	if("timer" not in self){timer = 300 * (1+skill_get("Filtering Teeth"));}
	timer--;
	if(timer < 40){image_alpha = 0;}
	if(timer < 30){image_alpha = 1;}
	if(timer < 20){image_alpha = 0;}
	if(timer < 10){image_alpha = 1;}
	if(timer <= 0){instance_destroy();}
}

#define ScrapArmsDraw
draw_self();