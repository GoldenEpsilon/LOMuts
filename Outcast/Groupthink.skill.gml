#define init
global.sprSkillIcon = sprite_add("../Sprites/Outcast/Blank.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("../Sprites/Outcast/Blank Icon.png", 1, 8, 8)
while(!mod_exists("mod", "lib")){wait(1);}
script_ref_call(["mod", "lib", "getRef"], "skill", mod_current, "scr");
global.alarms = [0,0,0,0,0,0,0,0,0,0,0,0];

#define skill_name
	return "Groupthink";
	
#define skill_text
	return "All enemies#share @ralarms@s";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return true;

#define skill_outcast
	return true;

#define skill_tip
	return "2+2=5";
	
#define skill_take
	sound_play(sndMut);

#define step
	with(enemy){
		for(var i = 0; i < 7; i++){
			var alrm = alarm_get(i);
			if(("alarm"+string(i)) in self){
				var alrm = variable_instance_get(self, "alarm"+string(i));
			}
			if(alrm > global.alarms[i]){
				global.alarms[i] = (alrm + global.alarms[i]) / 2;
			}else if(alrm > current_time_scale){
				alarm_set(i, max(global.alarms[i], current_time_scale));
			}
		}
		{
			var i = 11;
			var alrm = alarm_get(i);
			if(("alarm"+string(i)) in self){
				var alrm = variable_instance_get(self, "alarm"+string(i));
			}
			if(alrm > global.alarms[i]){
				global.alarms[i] = alrm;
			}else if(alrm > current_time_scale){
				alarm_set(i, max(global.alarms[i], current_time_scale));
			}
		}
	}
	for(var i = 0; i < 7; i++){
		global.alarms[i] -= current_time_scale * max(1,3 - skill_get(mod_current) * 0.5);
	}
	global.alarms[11] -= current_time_scale * max(1,3 - skill_get(mod_current) * 0.5);

//These are macros to slot in to make it easier to call lib functions.
#macro scr global.scr
#macro call script_ref_call