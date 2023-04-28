#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Dynamic Calves.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Dynamic Calves Icon.png", 1, 8, 8)

#define skill_name
	return "Dynamic Calves";
	
#define skill_text
	return "You move @wfaster@s#Moving fast @wslows@s enemies";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return "CHOO CHOO#I'M A TRAIN";
	
#define skill_type
	return "utility";
	
#define skill_take
	sound_play(sndMutRabbitPaw);
	with(Player){
		maxspeed+=0.3;
	}
	
#define skill_lose
	with(Player){
		maxspeed-=0.3;
	}
#define step
with(Player){
	if(object_index != Player){
		continue;
	}
	if("DynamicCalves" not in self){
		DynamicCalves = 0;
	}
	if(speed + friction + 0.2 > maxspeed){
		if(DynamicCalves < 12){
			DynamicCalves += 0.4;
		}
	}else if(DynamicCalves >= 1){
		DynamicCalves--;
	}else{
		DynamicCalves = 0;
	}
	with(enemy){
		if("DynamicCalves" in self){
			friction -= DynamicCalves;
			DynamicCalves = 0;
		}
		if("team" in self && team != other.team && distance_to_point(other.x,other.y) < 120){
			DynamicCalves = min((other.speed * other.DynamicCalves * speed * skill_get(mod_current)) / 250, speed - 0.1);
			friction += DynamicCalves;
		}
	}
}
/*
#define step
	with(Player){
		with(enemy){
			if("team" in self && team != other.team && distance_to_point(other.x,other.y) < other.speed*12 && distance_to_point(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction)) < other.speed*12){
				motion_add(point_direction(other.x,other.y,x,y),(other.speed-distance_to_point(other.x,other.y)/10)/8);
				motion_add(point_direction(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction),x,y),(other.speed-distance_to_point(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction))/10)/8);
			}
		}
		with(projectile){
			if("team" in self && team != other.team && distance_to_point(other.x,other.y) < other.speed*12 && distance_to_point(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction)) < other.speed*12){
				motion_add(point_direction(other.x,other.y,x,y),(other.speed-distance_to_point(other.x,other.y)/10)/8);
				motion_add(point_direction(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction),x,y),(other.speed-distance_to_point(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction))/10)/8);
			}
		}
	}
	script_bind_draw(customdraw, 0);
	
#define customdraw
	with(Player){
		draw_set_color(c_white);
		draw_set_alpha(0.2);
		draw_triangle(
			x+lengthdir_x(speed*5, direction)+lengthdir_x(speed*5, direction-90),y+lengthdir_y(speed*5, direction)+lengthdir_y(speed*5, direction-90),
			x+lengthdir_x(speed*5, direction)+lengthdir_x(speed*5, direction+90),y+lengthdir_y(speed*5, direction)+lengthdir_y(speed*5, direction+90),
			x+lengthdir_x(speed*10, direction),y+lengthdir_y(speed*10, direction), 0);
		//draw_circle(x,y,speed*12, 0);
		//draw_circle(x+lengthdir_x(speed*10, direction),y+lengthdir_y(speed*10, direction),speed*12, 0);
		draw_set_alpha(1);
	}
	instance_destroy();
*/