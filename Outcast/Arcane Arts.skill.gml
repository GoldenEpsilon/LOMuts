#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Arcane Arts.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)

#define skill_name
	return "Arcane Arts";
	
#define skill_text
	return "Reflected bullets#gain an @welement@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return false;

#define skill_outcast
	return true;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Flippity Floodle#Your weapon is now a noodle";
	
#define skill_take
	sound_play(sndMut);
	
#define step
with(Player){
	with(instances_matching_ne(projectile, "team", team)){
		if(fork()){
			var _t = other.team;
			wait(0);
			if(instance_exists(self) && team == _t && "arcanecheck" not in self){
				arcanecheck = true;
				switch(irandom(2)){
					case 0:
						image_blend = merge_color(image_blend, c_red, 0.5);
						with(instance_create(x,y,CustomObject)){
							name = "Fire Element";
							on_step = fire_step;
							creator = other;
							team = other.team;
							size = floor(log2(other.damage))+skill_get(mod_current)-1;
						}
						break;
					case 1:
						image_blend = merge_color(image_blend, c_aqua, 0.5);
						with(instance_create(x,y,CustomObject)){
							name = "Electric Element";
							on_step = electric_step;
							creator = other;
							team = other.team;
							size = floor(log2(other.damage))+skill_get(mod_current)-1;
						}
						break;
					case 2:
						image_blend = merge_color(image_blend, c_lime, 0.5);
						with(instance_create(x,y,CustomObject)){
							name = "Toxic Element";
							on_step = toxic_step;
							creator = other;
							team = other.team;
							size = floor(log2(other.damage))+skill_get(mod_current)-1;
						}
						break;
				}
			}
			exit;
		}
	}	
}

#define fire_step
	if(!instance_exists(creator)){
		if(size >= 2){
			instance_create(x,y,Explosion);
		}else if(size >= 1){
			instance_create(x,y,SmallExplosion);
		}
		instance_destroy();
		exit;
	}
	x = creator.x;
	y = creator.y;
	xstart = x;
	ystart = y;
	if(script_ref_call(mod_variable_get("mod", "LOMuts", "scr").chance_ct, max(size, 1), 2)){
		with(instance_create(x,y,Flame)){
			creator = other;
			team = creator.team;
			direction = random(360);
			image_angle = direction;
			speed = creator.size;
		}
	}

#define electric_step
	if(!instance_exists(creator)){
		if(size >= 2){
			with(instance_create(x,y,LightningBall)){
				creator = other;
				team = creator.team;
				direction = random(360);
				image_angle = direction;
				speed = 0;
			}
		}else if(size >= 1){
			repeat(3){
				with(instance_create(x,y,Lightning)){
					creator = other;
					team = creator.team;
					direction = random(360);
					image_angle = direction;
				}
			}
		}
		instance_destroy();
		exit;
	}
	x = creator.x;
	y = creator.y;
	xstart = x;
	ystart = y;
	if(script_ref_call(mod_variable_get("mod", "LOMuts", "scr").chance_ct, max(size, 1), 10)){
		with(instance_create(x,y,Lightning)){
			creator = other;
			team = creator.team;
			direction = random(360);
			image_angle = direction;
			alarm0 = 1;
			ammo = 2+other.size;
		}
	}

#define toxic_step
	if(!instance_exists(creator)){
		if(size >= 2){
			instance_create(x,y,ToxicGrenade);
		}else if(size >= 1){
			repeat(5){
				with(instance_create(x,y,ToxicGas)){
					creator = other;
					direction = random(360);
					image_angle = direction;
					speed = creator.size;
				}
			}
		}
		instance_destroy();
		exit;
	}
	x = creator.x;
	y = creator.y;
	xstart = x;
	ystart = y;
	if(script_ref_call(mod_variable_get("mod", "LOMuts", "scr").chance_ct, max(size, 1), 5)){
		with(instance_create(x,y,ToxicGas)){
			creator = other;
			direction = random(360);
			image_angle = direction;
			speed = creator.size;
		}
	}
	