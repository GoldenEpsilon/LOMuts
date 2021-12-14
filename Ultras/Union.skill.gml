#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "UNION";
#define skill_text    return "ALLIES @wCOMBINE@s";
#define skill_tip     return "You need a lot#to start the fusion";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "rebel";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
#define skill_mimicry return false; //I should set this to true once I test it

#define step
with(Player){
	if("homunculus" in self){
		with(homunculus){
			leaderstep();
		}
	}
	with(instances_matching(Ally, "team", team)){
		var player = other;
		if(("homunculus" in player && instance_exists(player.homunculus)) || instance_number(Ally) >= 6){
			if("homunculus" not in player || !instance_exists(player.homunculus)){
				with(instance_create(x,y,CustomObject)){
					team = other.team;
					name = "HomonculusLead";
					owner = player;
					player.homunculus = self;
					homunculusPos = -1;
					homunculusNum = 0;
					zspeed = 0;
					grav = 0.5;
					state = "idle";
					timer = 100;
					z = 0;
					animspeed = 2;
					positionNum = 8;
					size = 1;
				}
			}
			with(instance_create(x,y,CustomHitme)){
				maxhealth = other.maxhealth;
				my_health = other.my_health;
				sprite_index = sprAllyIdle;
				mask_index = mskNone;
				image_speed = 0.4;
				team = other.team;
				name = "Homonculus";
				on_hurt = homunhurt;
				homunculus = player.homunculus;
				homunculusPos = homunculus.homunculusNum;
				homunculus.homunculusNum++;
				z = 0;
			}
			instance_delete(self);
		}
	}
}
with(instances_matching_ne(CustomHitme, "homunculus", null)){
	if(instance_exists(homunculus)){
		homunstep(homunculus, homunculusPos);
	}else{
		homunhurt(my_health);
	}
}

#define homunstep(leader, pos)
var positions = [];
switch(leader.state){
	case "idle":
		positions = [[0,0,30 + sin(current_frame/10 + 2)*2],[10,70,0],[10,-70,0],[0,0,12 + sin(current_frame/10 + 1.5)*2],[10,-90,20 + sin(current_frame/10+1)*2],[10,90,20 + sin(current_frame/10+1)*2],[20,80,15 + sin(current_frame/10)*2],[20,-80,15 + sin(current_frame/10)*2]];
		break;
	case "walk":
		positions = [[0,0,30],[15,10,0],[10,-170,0],[0,0,15],[10,-90,20],[10,90,20],[20,60,15],[20,-110,15]];
		break;
	case "walk2":
		positions = [[0,0,30],[10,170,0],[15,-10,0],[0,0,15],[10,-90,20],[10,90,20],[20,110,15],[20,-60,15]];
		break;
	case "punch":
		positions = [[0,0,30],[10,70,0],[10,-70,0],[0,0,15],[20,-130,20],[20,30,20],[30,-10,15],[20,-110,15]];
		break;
	case "punch2":
		positions = [[0,0,30],[10,70,0],[10,-70,0],[0,0,15],[20,-30,20],[20,130,20],[20,110,15],[30,10,15]];
		break;
	case "jumpsquat":
		positions = [[0,0,20],[10,70,0],[10,-70,0],[0,0,10],[10,-90,15],[10,90,15],[20,60,10],[20,-60,10]];
		break;
	case "jump":
		positions = [[0,0,35],[10,90,0],[10,-90,0],[0,0,15],[10,-90,25],[10,90,25],[20,90,30],[20,-90,30]];
		break;
}
var position = positions[pos % array_length(positions)][0];
var offset = floor((leader.homunculusNum - (pos % array_length(positions)) - 1) / array_length(positions));
var ringPos = floor(pos / array_length(positions));
var ring = 3;
while(ringPos >= ring){
	ringPos -= ring;
	ring *= 2;
}
if(ringPos == 0 && offset == floor(pos / array_length(positions))){
	ringPos += 0.5;
	ring /= 2;
}
var offsetx = lengthdir_x(3 * ring, (360*ringPos)/ring);
var offsetz = lengthdir_y(3 * ring, (360*ringPos)/ring);
var rot = positions[pos % array_length(positions)][1] + leader.direction;
moveTo(leader,lengthdir_x(position * (leader.size/3 + 0.5), rot) + offsetx,lengthdir_y(position * (leader.size/3 + 0.5), rot),positions[pos % array_length(positions)][2] * (leader.size/3 + 0.5) + offsetz);
if(my_health <= 0){
}

#define homunhurt
	my_health -= argument0;
	sound_play(snd_hurt);
	nexthurt = current_frame + 5;
	image_index = 0;
	image_speed = 0.5;
	if my_health <= 0{
		sound_play(sndAllyDead);
		with(instance_create(x,y,Corpse)){
			sprite_index = sprAllyDead;
			mask_index = mskNone;
			team = other.team;
			if(fork()){
				z = 1;
				zspeed = 8;
				hspeed = irandom(10)-5;
				vspeed = irandom(10)-5;
				while(z > 0){
					wait(0);
					mask_index = mskAlly;
					if(!place_meeting(x + hspeed,y+z,Floor)){
						hspeed *= -1;
					}
					if(!place_meeting(x,y+z + vspeed,Floor)){
						vspeed *= -1;
					}
					if(!place_meeting(x + hspeed,y+z + vspeed,Floor)){
						hspeed *= -1;
						vspeed *= -1;
					}
					mask_index = mskNone;
					if(!instance_exists(self)){exit;}
					z += zspeed * current_time_scale;
					y -= zspeed * current_time_scale;
					zspeed -= 1;
				}
				mask_index = mskAlly;
				exit;
			}
		}
		with(instances_matching_ge(CustomHitme, "homunculusPos", homunculusPos)){
			homunculusPos--;
		}
		if(instance_exists(homunculus)){
			homunculus.homunculusNum--;
		}
		instance_destroy();
	}

#define leaderstep
if(homunculusNum < 4){
	instance_destroy();
	exit;
}
var e = instance_nearest(x,y,enemy);
size = floor((homunculusNum - 1) / positionNum) + 2;
if(e != noone){var dist = distance_to_point(e.x,e.y);}
if(z > 0){zspeed -= grav;}else{zspeed = 0; z = 0;}
actionspeed = 1 + skill_get(mut_throne_butt);
if(timer <= 0){
	switch(state){
		case "idle":
			timer = 15;
			if(e != noone && dist < 150){
				direction = point_direction(x,y,e.x,e.y);
				if(dist < 75 && homunculusNum > 6){
					state = "punch";
					animspeed = 8;
					timer = 10;
					var ang = 5/size;
					repeat(4*size){
						with(instance_create(x,y,AllyBullet)){
							team = other.team;
							direction = other.direction + ang;
							image_angle = direction + ang;
							speed = 4;
						}
						ang *= -1;
						ang += 5/size * sign(ang);
					}
				}else{
					state = "jumpsquat";
				}
			}else{
				if(instance_exists(owner)){
					direction = point_direction(x,y,owner.x,owner.y);
					if(distance_to_point(owner.x,owner.y) > 75){
						state = "walk";
						speed = 4;
						friction = 0.25;
						timer = 15;
					}
				}else if(instance_exists(e)){
					direction = point_direction(x,y,e.x,e.y);
					if(dist > 75){
						state = "walk";
						speed = 4;
						friction = 0.25;
						timer = 15;
					}
				}
			}
			break;
		case "walk":
			state = "walk2";
			speed = 4;
			friction = 0.25;
			timer = 15;
			instance_create(x,y,PortalClear);
			break;
		case "walk2":
			friction = 1;
			state = "idle";
			timer = 5+random(5);
			instance_create(x,y,PortalClear);
			if(instance_exists(owner)){
				direction = point_direction(x,y,owner.x,owner.y);
				if(distance_to_point(owner.x,owner.y) > 75){
					state = "walk";
					speed = 4;
					friction = 0.25;
					timer = 15;
				}
			}else if(instance_exists(e)){
				direction = point_direction(x,y,e.x,e.y);
				if(dist > 75){
					state = "walk";
					speed = 4;
					friction = 0.25;
					timer = 15;
				}
			}
			break;
		case "punch":
			animspeed = 2;
			state = "idle";
			if(e != noone && dist < 75 && homunculusNum > 7){
				state = "punch2";
				animspeed = 8;
				var ang = 5/size;
				repeat(2*size){
					with(instance_create(x,y,AllyBullet)){
						team = other.team;
						direction = other.direction + ang;
						image_angle = direction + ang;
						speed = 4;
					}
					ang *= -1;
					ang += 5/size * sign(ang);
				}
			}
			friction = 1;
			timer = 10;
			break;
		case "punch2":
			animspeed = 2;
			state = "idle";
			friction = 1;
			timer = 25 + random(25);
			break;
		case "jumpsquat":
			state = "jump";
			zspeed = 5;
			speed = 5;
			friction = 0.1;
			timer = 20 * actionspeed;
			break;
		case "jump":
			state = "idle";
			friction = 1;
			timer = 25 + random(25);
			with(instance_create(x,y,PortalClear)){
				team = other.team;
				image_xscale = log2(other.size);
				image_yscale = log2(other.size);
			}
			var ang = 0;
			repeat(12*size * actionspeed){
				with(instance_create(x,y,AllyBullet)){
					team = other.team;
					direction = other.direction + ang;
					image_angle = direction + ang;
					speed = 4;
				}
				ang += 360/(12*size);
			}
			break;
	}
}
z += zspeed * current_time_scale;
timer -= actionspeed * current_time_scale;

#define moveTo(leader,px,py,pz)
if("animx" not in self){
	animx = 0;
	animy = 0;
	animz = 0;
}
y += z;
if(z > 10){
	spr_shadow = mskNone;
	mask_index = mskNone;
}else{
	spr_shadow = shd24;
	mask_index = mskAlly;
}
if(abs(animx - px) < leader.animspeed * current_time_scale * log2(leader.size)){
	animx = px;
}else if(animx > px){
	animx -= leader.animspeed * current_time_scale * log2(leader.size);
}else{
	animx += leader.animspeed * current_time_scale * log2(leader.size);
}
if(abs(animy - py) < leader.animspeed * current_time_scale * log2(leader.size)){
	animy = py;
}else if(animy > py){
	animy -= leader.animspeed * current_time_scale * log2(leader.size);
}else{
	animy += leader.animspeed * current_time_scale * log2(leader.size);
}
x = leader.x+animx;
y = leader.y+animy;
xprevious = x;
yprevious = y;

if(abs(animz - pz) < leader.animspeed * current_time_scale * log2(leader.size)){
	animz = pz;
}else if(animz > pz){
	animz -= leader.animspeed * current_time_scale * log2(leader.size);
}else{
	animz += leader.animspeed * current_time_scale * log2(leader.size);
}
z = leader.z + animz;

y -= z;
depth = -z/5 - 6;