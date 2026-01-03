#define nothing //dragonstrive says hi
#define init
global.sprSkillIcon 	= sprite_add("../Sprites/Main/Shocked Skin.png", 1, 12, 16);
global.sprSkillHUD		= sprite_add("../Sprites/Icons/Shocked Skin Icon.png", 1, 8, 8);

global.sprShock			= sprite_add("../Sprites/sprSkinSpawn.png",4,12,12);
global.sprHit			= sprite_add("../Sprites/sprSkinHit.png",4,12,12);

global.shock_skin_cont	= noone;

#macro energy_compat		false;
#macro eulers				2.7182818284; //don't ask

#define skill_name
	return "Crackle Cartilage";
	
#define skill_text
	return "@wBULLETS @yBLAST @sNEARBY @wENEMIES#@sWHEN THEY @wEXPIRE";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD; 
	
#define skill_wepspec
	return 1;

#define skill_tip
	if energy_compat && random(100) < 33 return "@wSHOCKED SKIN @sWORKS WITH @gENERGY @wMUTATIONS";
	return "SHOCK ABSORPTION";
	
#define skill_type
	return "offensive";

#define skill_take
//sounds only play if in the loading screen
    if(argument0 > 0 && instance_exists(LevCont)){
        
         // Sound:
        var _area = GameCont.area;
        if(_area == 101 || (is_string(_area) && mod_script_call("area", _area, "area_underwater"))){
            sound_play(sndOasisShoot);
        }
        else{
            sound_mutation_play();
        }
    }

#define step
	if instance_exists(Player) && !instance_exists(global.shock_skin_cont){
		global.shock_skin_cont = script_bind_begin_step(custom_step, 0);
	}
	
#define custom_step
	//clear step cont if uneeded
	if !instance_exists(Player) || !skill_get(mod_current) {
		instance_destroy();
		exit;
	}
	
	if instance_exists(projectile){
		//vanilla projectiles
		var v = instances_matching([Bullet1, BouncerBullet, UltraBullet],"shockedskin",null);
		if array_length(v) with v {
			shocktrack_vanilla();
		}
		
		//modded projectiles
		var m = instances_matching(instances_matching(CustomProjectile,"ammo_type",1),"shockedskin",null);
		if array_length(m) with m {
			shocktrack_modded();
		}
	}
	
#define shocktrack_vanilla
	shockedskin = true;

	//fork
	if fork() {
		var _x = x + hspeed_raw;
		var _y = y + vspeed_raw;
		var _xp = xprevious;
		var _yp = yprevious;
		var _team = team;
		var _creator = creator;
		var _damage = damage;
		var _dir = direction;
		var _spd = speed;
		var _depth = depth;
		var _spr = sprite_index;
		while instance_exists(self) {
			_x = x + hspeed_raw;
			_y = y + vspeed_raw;
//			_xp = xprevious + hspeed_raw;
//			_yp = yprevious + vspeed_raw;
			_dir = direction;
//			_spd = speed;
			_team = team;
			_creator = creator;
			_damage = damage;
			_depth = depth;
			wait 0;
		}
		
		//explosion
		repeat skill_get(mod_current) shocked_skin_zap(_damage,_x,_y,_xp,_yp,_spd,_dir,_team,_creator,_depth,_spr);
		
		exit;
	}

#define shocktrack_modded
	//wrap projectile
	shockedskin = true;
	shockskin_base_damage	= damage; //compat for projectiles that pierce and lose damage (ie, magnums)
	shockskin_base_sprite	= sprite_index;
	shockskin_old_destroy 	= on_destroy;
	on_destroy				= script_ref_create(shocktrack_on_destroy_wrapped);

#define shocktrack_on_destroy_wrapped
	skill_get(mod_current) shocked_skin_zap(shockskin_base_damage,x,y,xprevious,yprevious,speed,direction,team,creator,depth,shockskin_base_sprite);
	script_ref_call(shockskin_old_destroy);

#define shocked_skin_zap(_damage,_x,_y,_xp,_yp,_spd,_dir,_team,_creator,_depth,_spr) //some of these arguments are unused
	
	var sg = skill_get(mod_current);
	
	#macro flat_range_mod	 1.33;

	with instance_create(_x,_y,CustomProjectile){
		xprevious			= _x;
		yprevious			= _y;
		
		sprite_index		= mskNone;
		mask_index			= mskReviveArea;
		depth				= -3;
		
		creator				= _creator;
		team				= _team;
		
		damage				= _damage/2;
		force				= _damage/3;
		
		image_xscale		= (2.360055 - 1.423834 * power(eulers,(-0.02291421*_damage))) * flat_range_mod; // i LOVE fitmycurve!!!!
		image_yscale		= image_xscale;
		
		canhit				= true;
		hashit				= false;
		nearest_valid		= noone;
		
		animate				= false;
		anim_max			= 7 + irandom_range(-1,1);
		zap_width			= image_xscale;
		
		shockedskin			= true; //just in case.
		
		zapx				= _x;
		zapy				= _y;
		zapx_end			= _x;
		zapy_end			= _y;
		zap_dir				= 0;
		
		comp_fist			= true; //just in case, again.
		
		//make this count as energy for mod compat if set to true (gepsi's disgression)
		if energy_compat {
			var brain = skill_get(mut_laser_brain);
			if brain {
				damage *= 1 + (0.5 * brain);
				anim_max += 2 * brain;
			}
			var echo = skill_get("Echo State Network");
			if echo {
				image_xscale *= 1 + (0.5 * echo);
				image_yscale = image_xscale;
				zap_width += echo/2;
			}
			
			ammo_type		= 5;
			is_lightning	= true;
		}
		else {
			ammo_type = -1; //may change this
		}
		
		on_wall		= nothing;
		on_hit		= script_ref_create(shocked_zap_hit);
		on_end_step	= script_ref_create(shocked_zap_endstep);
		on_draw		= script_ref_create(shocked_zap_draw);
	
		return self;
	}

#define shocked_zap_hit
	if !canhit exit;
	
	//try to avoid hitting the closest target unless you have to.
	var n =  instance_nearest(x,y,hitme);
	if n.team != team && n.id == other.id && place_meeting(x,y,n) {
		nearest_valid = n;
	}
	else {
		shocked_zap_damage(other);
	}

#define shocked_zap_damage(_inst)
	//vars
	canhit = false;
	hashit = true;
	animate = anim_max;
	zap_dir = point_direction(x,y,_inst.x,_inst.y);
	direction = zap_dir;
	zapx_end = _inst.x;
	zapy_end = _inst.y;
	
	//hit
	var d =  instance_is(_inst,Player) ? ceil(damage) : damage //round for players;
	projectile_hit(_inst,d,force,);
	
	//effects
	with instance_create(zapx,zapy,LightningSpawn){
		sprite_index = global.sprShock;
		image_angle = other.zap_dir;
		image_speed = 0.5;
		image_xscale = 0.75 * max(1,(other.image_xscale/2));
		image_yscale = image_xscale;
		depth = other.depth;
	}
	with instance_create(zapx_end,zapy_end,LightningHit){
		sprite_index = global.sprHit;
		image_angle = random(360);
		image_speed = 0.5;
		image_xscale = 0.75 * max(1,(other.image_xscale/2));
		image_yscale = image_xscale;
		depth = other.depth;
	}
	
	//sound
	sound_play_pitchvol(sndLightningCannon,1 + random(0.25),(image_xscale/3) - 0.4);
	sound_play_pitchvol(sndLightningReload,1.1 + random(0.25),1);

#define shocked_zap_endstep
	//hit nearest valid if it's the only option
	if canhit && instance_exists(nearest_valid) && place_meeting(x,y,nearest_valid){
		shocked_zap_damage(nearest_valid);
	}
	
	if !hashit {
			with instance_create(zapx_end,zapy_end,LightningHit){
				sprite_index = global.sprHit;
				image_angle = random(360);
				image_speed = 0.5;
				image_xscale = 0.75 * max(1,(other.image_xscale/2));
				image_yscale = image_xscale;
				depth = other.depth;
			}
			
	sound_play_pitchvol(sndLightningCannon,1.5 + random(0.25),(image_xscale/3) - 0.4);
	sound_play_pitchvol(sndLightningReload,1.5 + random(0.25),1);
	}
	
	if !animate { instance_destroy(); exit;}
	
#define shocked_zap_draw
	if animate {
		animate -= current_time_scale;
		var col = (animate/anim_max) <= 0.6 ? c_white : c_black
		var len = point_distance(zapx,zapy,zapx_end,zapy_end);
		draw_sprite_ext(sprBoltTrail,1,zapx,zapy,len,zap_width * (animate/anim_max),zap_dir,col,1);
	}
	else instance_destroy();
	

#define smoke_burst
var xx = argument[0], yy = argument[1];
var num = argument_count > 2 ? argument[2] : 6;
	var r = [];

	repeat num {
		with instance_create(xx,yy,Smoke){
			speed		= 1 + random(3);
			direction	= random(360);
			depth		+= 1;
			array_push(r,self);
		}
		
		with instance_create(xx,yy,Dust){
			speed		= 3 + random(3);
			direction	= random(360);
			depth		+= 1;
			array_push(r,self);
		}
	}
	
	return r;
	
//-------------Mutation Sounds---------------//
#define sound_mutation_play()
	sound_play(sndMut);
	with instance_create(0, 0, CustomObject){
		lifetime = 0;
		stage = 0;
		pitch = 1;
		on_step = sound_step
	}
	
#define sound_step
//GEPSI, IT'S ON YOU TO MAKE A NEW SOUND EFFECT
/*
	lifetime += current_time_scale;
	if lifetime > 5 && stage = 0{
		stage++;
		sound_play(sndEmpty)
		sound_play_pitchvol(sndNadeReload, 1, 2)
	}
	if lifetime > 10 && stage = 1{
		stage++;
		sound_play(sndEmpty)
		sound_play_pitchvol(sndNadeReload, 1.1, 2)
	}
	if lifetime > 16 && stage = 2{
		stage++;
		sound_play(sndEmpty)
		sound_play_pitchvol(sndNadeReload, 1.2, 2)
	}
	if lifetime > 19 && stage = 3{
		stage++;
		sound_play_pitchvol(sndTripleMachinegun, 1, 1)
	}
    if lifetime > 22 && stage = 4{
		stage++;
		sound_play_pitchvol(sndTripleMachinegun, 1.2, 1)
}		
    if lifetime > 27 && stage = 5{
		stage++;
		sound_play_pitchvol(sndTripleMachinegun, 1.2, 1)
}
   if lifetime > 29 && stage = 6{
		stage++;
		sound_play_pitchvol(sndExplosion, 1.2, .7)
		sound_play(sndFlyDead)
		sound_play_pitchvol(sndExplosion, 1.1, .8)
}
   if lifetime > 33 && stage = 7{
		stage++;
		sound_play(sndBanditDie)
		sound_play_pitchvol(sndExplosionXL, 1.1, 0.9)
}
/*


