#define nothing //dragonstrive says hi
#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Rocket Casings.png", 1, 12, 16);
global.sprSkillHUD = sprite_add("Sprites/Icons/Rocket Casings Icon.png", 1, 8, 8);
global.sprRocketExplo = sprite_add("Sprites/RocketExplo.png", 7, 12, 12);
global.sprRocketExploGreen = sprite_add("Sprites/RocketExploGreen.png", 7, 12, 12);
global.sprBlastS = sprite_add("Sprites/sprSmallYellowExplosion.png", 7, 12, 12);
global.sprBlastM = sprite_add("Sprites/sprYellowExplosion.png", 9, 24, 24);

global.casings_cont = noone;

#define skill_name
	return "Rocket Casings";
	
#define skill_text
	return "@wFASTER BULLETS#@wBULLETS @sCREATE @wBLASTS";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "ESCAPE VELOCITY";//"WHOOSH"; //feel free to revert the tip i just think this is neat
	
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
	if instance_exists(Player) && !instance_exists(global.casings_cont){
		global.casings_cont = script_bind_step(custom_step, 0);
	}
	
#define custom_step
	//clear step cont if uneeded
	if !instance_exists(Player) || !skill_get(mod_current) {
		instance_destroy();
		exit;
	}
	
	if instance_exists(projectile){
		//vanilla projectiles
		var v = instances_matching([Bullet1,UltraBullet,HeavyBullet,BouncerBullet],"rocketcasings",null);
		if array_length(v) with v {
			rc_vanilla();
		}
		
		//modded projectiles
		var m = instances_matching(instances_matching(CustomProjectile,"ammo_type",1),"rocketcasings",null);
		if array_length(m) with m {
			rc_modded();
		}
	}
	
#define rc_vanilla
	//general effects
	rc_general();
	
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
		rocket_casings_blast(_damage,_x,_y,_xp,_yp,_spd,_dir,_team,_creator,_depth);
		
		exit;
	}

#define rc_modded
	//general effects
	rc_general();
	
	//wrap projectile
	casings_damage			= damage; //compat for projectiles that pierce and lose damage (ie, magnums)
	casings_old_destroy 	= on_destroy;
	on_destroy				= script_ref_create(rc_on_destroy_wrapped);

#define rc_on_destroy_wrapped
	rocket_casings_blast(casings_damage,x,y,xprevious,yprevious,speed,direction,team,creator,depth);
	script_ref_call(casings_old_destroy);

#define rc_general
	rocketcasings = true;
	if speed > 0 {
		speed += 4;
	}
	if "force" in self {
		force *= 2;
	}

#define rocket_casings_blast(_damage,_x,_y,_xp,_yp,_spd,_dir,_team,_creator,_depth) //some of these arguments are unused
	
	#macro spr_S					global.sprBlastS
	#macro spr_M					global.sprBlastM
	
	#macro radius_ExplosionS		12
	#macro radius_ExplosionM		24

	var sg = skill_get(mod_current);

	with instance_create(_x,_y,CustomProjectile){
		xprevious			= x;
		yprevious			= y;
		
		name				= "rocketCasingsBlast";
		ammo_type			= 1;
		rocketcasings		= true; //please no recursion
		
		team				= _team;
		creator				= _creator;
		
		//assign explosion sprite and size based on damage
		//i used mycurvefit to fit some points: (3,7.6), (7,12), (25,18), (60,24), to give smooth damage to ratio scaling
		var _r = 1074.829 + (-19.87905 - 1074.829)/(1 + power(_damage/29061220000.000004,0.1589779));
		
		if _r <= radius_ExplosionS {
			sprite_index		= spr_S;
			image_xscale		= (_r/radius_ExplosionS);
			image_yscale		= image_xscale; //something wierdy going on here
			sound				= sndExplosionS;
		}
		else {
			sprite_index		= spr_M;
			image_xscale		= (_r/radius_ExplosionM);
			image_yscale		= image_xscale;
			sound				= sndExplosion;
		}
		
		radius				= _r; //we track this for dynamic wall damage later
		
		mask_index			= sprite_index;
		
		depth				= _depth;
        image_index         = 0;
        image_alpha         = 0;
        
        anim_speed			= 0.6;
        anim_alpha			= 1;
		
		hitlist             = [];
		hitwalls			= [];
		damage				= _damage * (sg/3);
		force				= 3 * sg;
		
		wall_maxhp			= 20;
		wallpower_mod		= 1;
		
		smoke				= max(1,ceil(sqrt(_damage)) - 2);
		shake				= _damage/1.5;
		
		sound_p				= 1.5 * (1/power(_damage,0.2));
		
		typ					= 0; //immune to shields
		nopopo				= 2; //immune to IDPD blasts
		speed				= 0;
		
        appear_timer        = 1;
        has_blasted         = false;
        
        hitid				= [sprite_index, "ROCKET CASINGS BLAST"];
        
        on_step				= script_ref_create(rocketCasingsBlast_step);
        on_hit				= script_ref_create(rocketCasingsBlast_hit);
        on_wall				= script_ref_create(rocketCasingsBlast_wall);
        on_destroy			= nothing;
		
		return self;
	}

#define rocketCasingsBlast_step
    if appear_timer >= 0 {
        appear_timer -= current_time_scale;
        image_speed = 0;
        image_alpha = 0;
    }
    else if !has_blasted{
        has_blasted = true;
        image_index = 0;
        image_speed = anim_speed;
        image_alpha = anim_alpha;
        
        //sound, smoke, shake
        sound_play_pitchvol(sound,(1.2 + random(0.2)) * sound_p,0.7);
        smoke_burst(x,y,smoke);
        view_shake_at(x,y,shake);
    }
    
    if (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0) instance_destroy();

#define rocketCasingsBlast_hit
	if !has_blasted exit;
    if array_find_index(hitlist,other) == -1{
    	var _d = (instance_is(other,Player) ? ceil(damage) : damage); //round damage for players
        projectile_hit(other,_d,force,point_direction(x,y,other.x,other.y));
        array_push(hitlist,other);
    }

#define rocketCasingsBlast_wall
	if !has_blasted exit;
	
	//over time wall destruction
	with other {
		if "rc_wall_durability" not in self{
			rc_wall_durability = other.wall_maxhp;
			rc_wall_durability_max = rc_wall_durability;
			instance_create(x,y,FloorExplo);
		}

		if array_find_index(other.hitwalls,self) == -1 {
			array_push(other.hitwalls,self);
			
			var d = (point_distance(x + 8,y + 8,other.x,other.y)/other.radius);
			rc_wall_durability -= other.damage * other.wallpower_mod * random_range(0.9,1.1) / d;
			var m = 90;
			var _c = min(color_get_value(image_blend), (256 - m) + m * (rc_wall_durability/rc_wall_durability_max));
			image_blend = make_color_hsv(0,0,_c);
			
			if !rc_wall_durability{
				with instance_create(x,y,FloorExplo){
					instance_destroy();
				}
				instance_destroy();
			}
		}
	}

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



