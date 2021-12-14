#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "GENERALIST";
#define skill_text    return "YOU HAVE THREE @wSNARES@s";
#define skill_tip     return "Choke 'em and Smoke 'em";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "plant";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
#define skill_mimicry return true;

#define step
var primary = 0;
with(Tangle){
	if(instance_exists(self) && p != -1){
		if(primary == 0){
			if(array_length(instances_matching(Tangle, "generalistp", p)) > 2){
				with(instances_matching(Tangle, "generalistp", p)[array_length(instances_matching(Tangle, "generalistp", p))-1]){
					instance_destroy();
				}
			}
			primary = self;
			generalistp = p;
			p = -1;
		}else{
			generalistowner = primary;
			p = -1;
		}
	}
	if("generalistowner" in self){
		if(!instance_exists(generalistowner)){
			instance_destroy();
		}
	}
}