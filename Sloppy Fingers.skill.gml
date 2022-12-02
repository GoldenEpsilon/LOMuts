#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Sloppy Fingers.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Sloppy Fingers Icon.png", 1, 8, 8)
script_ref_call(["mod", "lib", "getHooks"], "skill", mod_current);

#define skill_name
	return "Sloppy Fingers";
	
#define skill_text
	return "Faster Reload (-3 @wframes@s)#Less Accuracy";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return choose("Whoops!", "Not even eyesight fixes sloppiness");
	
#define skill_take
	sound_play(sndMutTriggerFingers);
	if instance_exists(Player) {
		with Player {
			accuracy *= 1.5;
		}
	}
	
#define skill_lose
	if instance_exists(Player) {
		with Player {
			accuracy /= 1.5;
		}
	}

#define late_step
	with(Player){
		if("sloppyprevreload" not in self){sloppyprevreload = reload;}
		if(reload > sloppyprevreload){
			reload -= 3;
		}
		sloppyprevreload = reload;
	}