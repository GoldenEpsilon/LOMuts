#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "POSITIVITY";
#define skill_text    return "BOUNCING @wSPEEDS@s YOU UP#MOVING @wFAST@s PUSHES STUFF AWAY";
#define skill_tip     return "Whoosh";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "frog";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
#define skill_mimicry return true;

#define step
with(Player){
	if("positivitySpeed" not in self){
		positivitySpeed = 0;
	}
	if(maxspeed < 8 && place_meeting(x + hspeed, y + vspeed, Wall)){
		if(fork()){
			wait(0);
			
			if(!instance_exists(self)){ exit; }
			
			var prevdir = direction;
			
			sound_play_pitch(sndFrogStart, 1 + random(0.2));
			sound_play_pitch(sndWrench, 1.4 + random(0.2));
			
			with(instance_create(x, y, ImpactWrists)) {
				depth = other.depth - 1;
				image_speed += 0.2;
			}
			
			maxspeed += 0.5;
			positivitySpeed += 0.5;
			
			exit;
		}
	}
	if(positivitySpeed > 0){
		maxspeed -= 0.025;
		positivitySpeed -= 0.025;
	}
}
with(Player){
	with(enemy){
		if(team != other.team && distance_to_point(other.x,other.y) < other.speed*12 && distance_to_point(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction)) < other.speed*12){
			motion_add(point_direction(other.x,other.y,x,y),(other.speed-distance_to_point(other.x,other.y)/10)/4);
			motion_add(point_direction(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction),x,y),(other.speed-distance_to_point(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction))/10)/4);
		}
	}
	with(projectile){
		if(team != other.team && distance_to_point(other.x,other.y) < other.speed*12 && distance_to_point(other.x+lengthdir_x(speed*10, other.direction),other.y+lengthdir_y(speed*10, other.direction)) < other.speed*12){
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