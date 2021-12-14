#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "FISSION";
#define skill_text    return "HITTING ENEMIES WITH THE#@gRAD BEAM@s INSTANTLY @wREFUNDS@s";
#define skill_tip     return "Feed from all";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "horror";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool

#define step
with(instances_matching_ge(hitme, "raddrop", 0)){
	if("prevRad" not in self){
		prevRad = raddrop;
	}
	if(raddrop > prevRad){
		GameCont.rad += raddrop - prevRad;
	}
	raddrop = prevRad;
}