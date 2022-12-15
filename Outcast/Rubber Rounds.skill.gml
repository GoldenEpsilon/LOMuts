#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");

#define skill_name
	return "Rubber Rounds";
	
#define skill_text
	return "Enemy shots have a#chance to @wbounce@s#and become @wfriendly@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "Shlorp";
	
#define skill_take
	sound_play(sndMut);

#define step
	with(Player){
		with(instances_matching(instances_matching_ne(instances_matching_ne(projectile, "team", 0), "team", team),"rubber",null)){
			if(object_index != TrapFire && object_index != EnemySlash){
				rubber = random_range(0, skill_get(mod_current)) > 0.5;
				if(rubber){
					rubberowner = other;
					rubbercol = player_get_color(rubberowner.index);
				}
			}
		}
	}
	with(instances_matching_ne(projectile, "rubberowner", null)){
		if(instance_exists(rubberowner)){
			if(rubber == 1){
				if(place_meeting(x + hspeed, y + vspeed, Wall)){
					image_blend = rubbercol;
					team = rubberowner.team;
					instance_create(x, y, ImpactWrists).image_blend = rubbercol;
					rubber = 0;
					move_bounce_solid(false);
					image_angle = direction;
					sleep(5);
					view_shake_at(x, y, 5);
					direction += random_range(-2, 2);
					sound_play_pitchvol(sndCanBounce2, random_range(0.4, 0.5), 3);
				}
			}else{
				with(instance_create(x, y, BoltTrail)){
					image_blend = other.rubbercol;
					image_xscale = other.speed;
					image_yscale = other.sprite_width / 5;
					image_angle = other.direction;
				}
			}
		}
	}

#macro call script_ref_call
#macro scr global.scr