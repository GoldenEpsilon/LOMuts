#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "ARMORY";
#define skill_text    return "@wBLADES@s ROTATE AROUND YOU#WHEN @wSHIELDED@s";
#define skill_tip     return "Stationary Beyblade";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "crystal";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool

#define step
	with(CrystalShield){
		var c = creator;
		
		 // Slower Shield Decay:
		time -= current_time_scale / 2;
		
		if(instance_exists(c)){ // If the player exists
			for(var i = (-current_frame*8) % 360; i < 360 + ((-current_frame*8) % 360); i += 90){
				with(instance_create(x + lengthdir_x(15, i),y + lengthdir_y(15, i),CustomSlash)){
					sprite_index = other.sprite_index;
					mask_index = sprShield;
					image_index = other.image_index;
					image_yscale = 2;
					direction = i - 45;
					image_angle = direction - 45;
					team = other.team;
					damage = 2;
					force = 5;
					candeflect = false;
					on_hit = sword_hit;
					on_projectile = sword_null;
					on_grenade = sword_null;
					on_deflect = sword_null;
				}
			}
		}
	}
	
#define sword_null

#define sword_hit
if projectile_canhit_melee(other){
	projectile_hit(other,damage,force,direction - 45)
}