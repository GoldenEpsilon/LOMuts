#define init
	global.marker = sprite_add("Sprites/Marker.png", 4, 3, 3)
	//this is set to true when lib is done loading, check this before using lib in step events and such
	global.libLoaded = false;
	if(fork()){
		//wait for lib to be loaded, first of all.
		while(!mod_exists("mod", "lib")){wait(1);}

		//This tells lib to check this mod for hooks and to give the global variable (in this case global.scr) the list of functions lib can use
		script_ref_call(["mod", "lib", "getRef"], "mod", mod_current, "scr");

		//This is where you put what modules you want to load.
		var modules = ["libImprovements", "libMuts", "libStats", "libSettings", "libWeps", "libPickups", "libAutoUpdate"];
		with(modules) call(scr.import, self);
		//Lib is done loading, set the global variable.
		global.libLoaded = true;
		exit;
	}

	global.canMutTokens = true;
	global.canOutcast = false;
	while(!global.libLoaded){wait(1);}
	call(scr.add_setting, "LOMuts", "canMutTokens", "Mutation Tokens");
	call(scr.autoupdate, "LOMuts", "GoldenEpsilon/LOMuts");
	game_start();

#define game_start
	var _skills = mod_get_names("skill");
	with(_skills){
		if(!skill_get(self) && mod_script_exists("skill", self, "skill_outcast") && mod_script_call("skill", self, "skill_outcast")){
			skill_set_active(self, false);
		}
	}

#define step
	with(SkillIcon){
		if(is_string(skill) && mod_script_exists("skill", skill, "skill_reusable") && mod_script_call("skill", skill, "skill_reusable")){
			noinput = 2;
			with(Player){
				if((button_pressed(index, "fire") && point_in_rectangle(mouse_x[index], mouse_y[index], other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom)) || 
				button_pressed(index, "key" + string(other.num+1)) || 
				(other.creator.select == other.num && button_pressed(index, "okay"))){
					//TODO: https://discord.com/channels/846661738803626014/882447494892642315/917906721538727957
					mod_script_call("skill", other.skill, "skill_take");
				}
			}
		}
	}

#define draw
	with(instances_matching(hitme, "marked", true)){
		if("markTimer" not in self){
			markTimer = 10;
		}
		
		draw_sprite_ext(global.marker, 0, bbox_left - markTimer, bbox_top - markTimer, 1, 1, 0, c_white, (10-markTimer)/10);
		draw_sprite_ext(global.marker, 1, bbox_right + markTimer + 1, bbox_top - markTimer, 1, 1, 0, c_white, (10-markTimer)/10);
		draw_sprite_ext(global.marker, 2, bbox_left - markTimer, bbox_bottom + markTimer + 2, 1, 1, 0, c_white, (10-markTimer)/10);
		draw_sprite_ext(global.marker, 3, bbox_right + markTimer + 1, bbox_bottom + markTimer + 2, 1, 1, 0, c_white, (10-markTimer)/10);
		
		if(markTimer > 0){
			markTimer -= current_time_scale;
		}else{
			markTimer = 0;
		}
	}
	

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call