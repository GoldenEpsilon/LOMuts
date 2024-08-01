//Ty Dragonstrive!

#define nothing
#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Blank Utility.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Blank Utility Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");


	#macro xs_srt		1.2
	#macro ys_srt		0.7
	
	#macro xs_end		0.5		
	#macro ys_end		1.15
	
	//try fetching and then pruning to see if it speeds up the code

#define skill_name
	return "SHELL CELLULITE";
	
#define skill_text
	return "@wSHELL@s VELOCITY UP#@sSHELLS @wLINGER @sAFTER SLOWING DOWN#SHELLS @wABSORB@s PROJECTILES";
	
#define stack_text
	return "@wSHELLS@s ABSORB @wMORE@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "TEN TON SHOTGUN";
	
#define skill_take
	sound_play(sndMut)

#define skill_avail
	return 1;

#define step
	if instance_exists(projectile){
		var inst = instances_matching([Bullet2,FlameShell,UltraShell,FlakBullet,SuperFlakBullet,Slug,HeavySlug],"",null); //vanilla
		var cust = instances_matching(CustomProjectile,"ammo_type",2); //custom shells
		
		if array_length(inst) with inst {
			stall_shell_step()
			var is_blocking = false;
			with(call(scr.instances_meeting, x, y, instances_matching_ne(projectile, "team", team))){
				if(place_meeting(x,y,other)){
					is_blocking = true;
					other.damage -= damage*4/skill_get(mod_current);
					if other.speed > 0 {
						other.speed -= min(other.speed, damage);
					}
					instance_destroy();
					if other.damage <= 0 {
						break;
					}
				}
			}
			if is_blocking && damage <= 0 {
				instance_destroy();
				continue;
			}
		}
		
		if array_length(cust) with cust {
			stall_shell_step()
			var is_blocking = false;
			with(call(scr.instances_meeting, x, y, instances_matching_ne(projectile, "team", team))){
				if(place_meeting(x,y,other)){
					is_blocking = true;
					other.damage -= damage*4/skill_get(mod_current);
					if other.speed > 0 {
						other.speed -= min(other.speed, damage);
					}
					instance_destroy();
					break;
				}
			}
			if is_blocking && damage <= 0 {
				instance_destroy();
				continue;
			}
		}
	}

#define stall_shell_step
	if "cellulite_init" not in self {
		cellulite_init		= true;
		cellulite_frames	= random_range(10,20) + 15 * skill_get(mod_current);
		cellulite_max		= cellulite_frames;
		setback 			= 0;
		faux_friction		= friction;
		friction			= 0;
		start_xscale		= image_xscale;
		start_yscale		= image_yscale;
		image_xscale		*= xs_srt;
		image_yscale		*= ys_srt;
		speed				*= 1.2;
		
		if "wallbounce" not in self wallbounce = 0;
		
		
		if !wallbounce {
			safebounce = false;
			wallbounce ++;
		}
		else safebounce = true;
	}

	if cellulite_frames {
		prev_speed = speed;
		setback = min(setback + faux_friction * current_time_scale, prev_speed);
		
		//shells that coudn't bounce prior will just hug the wall
		//makes flame shells and toxic flechettes more effective
		if !wallbounce && !safebounce {
			setback = prev_speed;
			x = xprevious;
			y = yprevious;
		}
		
		if setback == prev_speed {
			cellulite_frames -= current_time_scale;
			var t = 1 - (cellulite_frames/cellulite_max);
			image_xscale = start_xscale * lerp(xs_srt,xs_end,t);
			image_yscale = start_yscale * lerp(ys_srt,ys_end,t);
			
			bonus = max(bonus,2); //shells deal more damage when stationary
			
			if !cellulite_frames {
				x += hspeed_raw;
				y += vspeed_raw;
				speed = 0;
				sound_play_pitchvol(sndFlakExplode,4 + random(1),0.15);
			}
		}
		
		//stall projectile without actually slowing it
		x -= lengthdir_x(setback,direction);
		y -= lengthdir_y(setback,direction);
	}
	

	
	
//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call