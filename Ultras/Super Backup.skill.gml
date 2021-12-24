#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "SUPER BACKUP";
#define skill_text    return "USING @bPORTAL STRIKE@s#SUMMONS FRIENDLY IDPD";
#define skill_tip     return "Allies from another time";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "rogue";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool

#define step
with(instances_matching(RogueStrike, "superbackup", null)){
	superbackup = 1;
	if(fork()){
		var _x = x;
		var _y = y;
		var _t = 0;
		var _i = 0;
		if("creator" in self){
			_t = creator.team;
		}
		if("creator" in self && "index" in creator){
			_i = creator.index;
		}
		while(instance_exists(self)){
			_x = x;
			_y = y;
			wait(0);
		}
		repeat(1 + (1 + skill_get(mut_throne_butt)) * GameCont.loops){
			var temp = instance_nearest(_x + irandom(100) - 50,_y + irandom(100) - 50,Floor);
			_x = temp.x + temp.sprite_width/2;
			_y = temp.y + temp.sprite_height/2;
			with(instance_create(_x,_y,CustomObject)){
				sprite_index = sprPopoPortal;
				image_speed = 0.4;
				image_index = 1;
				team = _t;
				index = _i;
				name = "SuperBackup";
				timer = 30;
				on_step = SuperBackup_step;
			}
		}
		exit;
	}
}
with(instances_matching(Grunt, "superbackup", true)){
	 // Shh, don't tell yokin but this is taken from Parrot in NTTE
	var	_lastDir = direction;
		
	 // Emergency Target:
	if(!instance_exists(_target)){
		with(charm_target(_target)){
			with(self[0]){
				x = other[1];
				y = other[2];
			}
		}
	}
	
	 // Increased Aggro:
	if(alarm1 > 0 && (current_frame % 1) < current_time_scale && instance_is(self, enemy)){
		var _aggroSpeed = ceil(((10 / max(1, size)) - 1) * max(1, current_time_scale));
		
		 // Boss Intro Over:
		if("intro" not in self || intro){
			 // Not Attacking:
			if(
				alarm2 < 0
				&& ("ammo" not in self || ammo <= 0)
				&& (sprite_index == spr_idle || sprite_index == spr_walk || sprite_index == spr_hurt)
				&& (!instance_exists(projectile)      || !array_length(instances_matching(projectile,      "creator", self)))
				&& (!instance_exists(ReviveArea)      || !array_length(instances_matching(ReviveArea,      "creator", self)))
				&& (!instance_exists(NecroReviveArea) || !array_length(instances_matching(NecroReviveArea, "creator", self)))
			){
				 // Not Shielding:
				if(!instance_exists(PopoShield) || !array_length(instances_matching(PopoShield, "creator", self))){
					alarm1 = max(alarm1 - _aggroSpeed, 1);
				}
			}
		}
	}
	
	
	for(var _alarmNum = 0; _alarmNum <= 10; _alarmNum++){
		var _alarm = alarm_get(_alarmNum);
		if(_alarm > 0 && _alarm <= ceil(current_time_scale)){
			var _playerPos = charm_target(_target);
			
			 // Call Alarm Event:
			with(self){
				if(_alarmNum != 2 || instance_exists(target) || !instance_is(self, Gator)){ // Gator Fix
					try{
						alarm_set(_alarmNum, 0);
						event_perform(ev_alarm, _alarmNum);
					}
					catch(_error){
						trace(_error);
					}
				}
			}
			
			 // Return Moved Players:
			with(_playerPos){
				with(self[0]){
					x = other[1];
					y = other[2];
				}
			}
			
			 // 1 Frame Extra:
			if(instance_exists(self)){
				_alarm = alarm_get(_alarmNum);
				if(_alarm > 0){
					alarm_set(_alarmNum, _alarm + 1);
				}
			}
			else break;
		}
	}
	
	 // Follow Leader:
	if(instance_exists(Player)){
		if("ammo" not in self || ammo <= 0){
			if(
				meleedamage <= 0
				|| "gunangle" in self
				|| ("walk" in self && walk > 0 && !instance_is(self, ExploFreak))
			){
				if(
					!instance_exists(_target)
					|| collision_line(x, y, _target.x, _target.y, Wall, false, false)
					|| distance_to_object(_target) > 80
					|| distance_to_object(Player) > 256
				){
					 // Player to Follow:
					if(!instance_exists(_follow)){
						_follow = instance_nearest(x, y, Player);
					}
					
					 // Stay in Range:
					if(instance_exists(_follow) && distance_to_object(_follow) > 32){
						motion_add_ct(point_direction(x, y, _follow.x, _follow.y), 1);
					}
				}
			}
		}
	}
	if(array_length(instances_matching_ne(enemy, "team", team)) == 0){
		my_health = 0;
	}
}

#define charm_target(_target)
	/*
		Targets a nearby enemy and moves the player to their position
		Returns an array containing the moved players and their previous position, [id, x, y]
	*/
	
	var	_playerPos   = [],
		_targetCrash = (!instance_exists(Player) && instance_is(self, Grunt)); // References player-specific vars in its alarm event, causing a crash
		
	 // Targeting:
	if(
		!instance_exists(_target)
		|| collision_line(x, y, _target.x, _target.y, Wall, false, false)
		|| !instance_is(_target, hitme)
		|| _target.team == variable_instance_get(self, "team")
		|| _target.mask_index == mskNone
	){
		_target = noone;
		
		var _inst = instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", 0), "mask_index", mskNone);
		if(array_length(_inst)){
			 // Team Check:
			if("team" in self){
				_inst = instances_matching_ne(_inst, "team", team);
			}
			
			 // Target Nearest:
			var _disMax = 1/0;
			if(array_length(_inst)) with(_inst){
				var _dis = point_distance(x, y, other.x, other.y);
				if(_dis < _disMax){
					if(!instance_is(self, prop)){
						_disMax = _dis;
						_target = self;
					}
				}
			}
		}
	}
	
	 // Move Players to Target (the key to this system):
	if("target" in self){
		if(!_targetCrash){
			target = _target;
		}
		
		with(Player){
			array_push(_playerPos, [self, x, y]);
			
			if(instance_exists(_target)){
				x = _target.x;
				y = _target.y;
			}
			
			else{
				var	_l = 10000,
					_d = random(360);
					
				x += lengthdir_x(_l, _d);
				y += lengthdir_y(_l, _d);
			}
		}
	}
	
	return _playerPos;

#define SuperBackup_step
timer -= current_time_scale;
if(timer < 0){
	repeat(irandom(1)+1){
		with(instance_create(x,y,Grunt)){
			team = other.team;
			index = other.index;
			_target = noone;
			_follow = noone;
			superbackup = true;
			strikechance = 256;
			with(instance_create(x,y,CustomObject)){
				name = "outline";
				target = other;
				index = other.index;
				on_draw = outline_draw;
			}
		}
	}
	instance_destroy();
}

#define outline_draw
if(!instance_exists(target)){
	instance_destroy();
	exit;
}
d3d_set_fog(1, player_get_color(target.index), 0, 0);
target.x++;
with(target){image_xscale *= right; draw_self(); image_xscale *= right;}
target.x-=2;
with(target){image_xscale *= right; draw_self(); image_xscale *= right;}
target.x++;
target.y++;
with(target){image_xscale *= right; draw_self(); image_xscale *= right;}
target.y-=2;
with(target){image_xscale *= right; draw_self(); image_xscale *= right;}
target.y++;
d3d_set_fog(0, 0, 0, 0);