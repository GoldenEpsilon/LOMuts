#define init
	global.sprSkillIcon = sprite_add("../Sprites/Main/Ultras/" + string_upper(string(mod_current)) + ".png", 1, 12, 16); 
	global.sprSkillHUD  = sprite_add("../Sprites/Icons/Ultras/" + string_upper(string(mod_current)) + ".png",  1,  9,  9);

#define skill_name    return "ADAPTABLE";
#define skill_text    return "REACHING @wMAX AMMO@s USES @yAMMO@s#TO GIVE YOU MORE @wMAX AMMO@s";
#define skill_tip     return "I have the tools";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_take    if(array_length(instances_matching(mutbutton, "skill", mod_current)) > 0) sound_play(sndBasicUltra);
#define skill_ultra   return "fish";
#define skill_avail   return 0; // Disable from appearing in normal mutation pool
#define skill_mimicry return true;

#define step
with(Player){
	for(var i = 1; i < array_length(ammo); i++){
		if(ammo[i] == typ_amax[i]){
			with(instance_create(x, y, PopupText)){
				msg = "ammo"
				switch(i){
					case 1:
						msg = "bullets"
					break;
					case 2:
						msg = "shells"
					break;
					case 3:
						msg = "bolts"
					break;
					case 4:
						msg = "explosives"
					break;
					case 5:
						msg = "energy"
					break;
					default:
						msg = "ammo " + i
					break;
				}
				text = "-"+string(floor(other.typ_amax[i]/5))+" " + msg + "#+5 max " + msg;
			}
			typ_amax[i] += 5;
			ammo[i] -= floor(typ_amax[i]/5);
		}
	}
}