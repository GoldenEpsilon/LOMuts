#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Brain Transfer.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Brain Transfer Icon.png", 1, 8, 8)
global.troll = false;

#define skill_name
	return "Brain Transfer";
	
#define skill_text
	return "@wReroll@s all weapon mutations#(This mutation is also refunded)";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_avail
	return GameCont.wepmuts >= 2 && (!instance_is(self, CustomObject) && !instance_is(self, CustomProp)) || instance_exists(Loadout);

#define skill_tip
	return "Refreshing";

#define skill_temp
	return 1;

#define skill_sacrifice return false; //metamorphosis compat thing
	
#define skill_take
	var rerolledMuts = 1;
	var wepskills=[]
	var modskills = mod_get_names("skill");
	with([mut_long_arms, mut_boiling_veins, mut_shotgun_shoulders, mut_recycle_gland, mut_laser_brain, mut_bolt_marrow]){
		array_push(wepskills,self);
	}
	with(modskills){
		if(is_string(self) && mod_script_exists("skill", self, "skill_wepspec") && mod_script_call("skill", self, "skill_wepspec")){
			array_push(wepskills,self);
		}
	}
	with(wepskills){
		if(skill_get(self) > 0){
			rerolledMuts += skill_get(self);
			skill_set(self, 0);
		}
	}
	GameCont.skillpoints += rerolledMuts;
	
	if(global.troll){
		var n = instance_number(Player);
		with(Player){
			instance_change(Revive, false);
			p = (p + 1) % n;
			instance_change(Player, false);
			visible = true;
		}
	}
	sound_play(sndMut);
	sound_play_pitch(sndMutant5Slct, 0.6);
	wait(8);
	sound_play(sndFreakPopoReviveArea);
	wait(16);
	sound_play_pitch(sndMutant5Slct, 1.4);