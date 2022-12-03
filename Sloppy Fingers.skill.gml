#define init
global.sprSkillIcon = sprite_add("Sprites/Main/Sloppy Fingers.png", 1, 12, 16)
global.sprSkillHUD = sprite_add("Sprites/Icons/Sloppy Fingers Icon.png", 1, 8, 8)
script_ref_call(["mod", "lib", "getHooks"], "skill", mod_current);

#define skill_name
	return "Sloppy Fingers";
	
#define skill_text
	return "Faster Reload, Less Accuracy#This effect ramps up as you fire";

#define skill_button
	sprite_index = global.sprSkillIcon;
	
#define skill_icon
	return global.sprSkillHUD;

#define skill_tip
	return choose("Whoops!", "Better eyesight can#help sloppiness");

#define late_step
	with(Player){
		if("sloppyprevreload" not in self){sloppyprevreload = 0;}
		if("sloppyderampspeed" not in self){sloppyderampspeed = 0;}
		if("sloppyramp" not in self){sloppyramp = 1;}
		if("sloppyprevramp" not in self){sloppyprevramp = sloppyramp;}
	
		sloppyprevramp = sloppyramp;
		
		accuracy /= sloppyprevramp;
		reloadspeed /= sloppyprevramp;
		
		if(reload > sloppyprevreload){
			sloppyramp = min(sloppyramp + abs(reload * 0.01) + 0.01, 2);
			sloppyderampspeed = 0;
		}
		sloppyprevreload = reload;
		sloppyramp = max(sloppyramp - sloppyderampspeed, 1);
		sloppyderampspeed = min(sloppyderampspeed + 0.00025, 1);
	
		accuracy *= sloppyramp;
		reloadspeed *= sloppyramp;
	}