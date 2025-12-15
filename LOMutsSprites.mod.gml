//> yeah ntte uses global.sprSkillIcon and global.sprSkillHud, refactor to work with that instead

#define init
global.sprites = {}
lq_set(global.sprites, mut_scarier_face, ["Sprites/Extras/Scarier Face.png", "reset", ""]);
lq_set(global.sprites, "Brain Transfer", [sprite_add("Sprites/Main/Brain Transfer.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Brain Transfer.png", 1, 12, 16), sprite_add("Sprites/Alt/Brain Transfer.png", 1, 12, 16), sprite_add("Sprites/Alt/Brain Transfer 2.png", 1, 12, 16)]);
lq_set(global.sprites, "Compressing Fist", [sprite_add("Sprites/Main/Compressing Fist.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Compressing Fist.png", 1, 12, 16), sprite_add("Sprites/Alt/Compressing Fist.png", 1, 12, 16)]);
lq_set(global.sprites, "Confidence", [sprite_add("Sprites/Main/Confidence.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Confidence.png", 1, 12, 16)]);
lq_set(global.sprites, "Double Vision", [sprite_add("Sprites/Main/Double Vision.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Double Vision.png", 1, 12, 16)]);
lq_set(global.sprites, "Duplicators", [sprite_add("Sprites/Main/Duplicators.png", 1, 12, 16),sprite_add("Sprites/Dev Art/Duplicators.png", 1, 12, 16)]);
lq_set(global.sprites, "Dynamic Calves", [/*sprite_add("Sprites/Main/Dynamic Calves.png", 1, 12, 16), */sprite_add("Sprites/Alt/Dynamic Calves.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Dynamic Calves.png", 1, 12, 16)]);
lq_set(global.sprites, "Energized Intestines", [sprite_add("Sprites/Main/Energized Intestines.png", 1, 12, 16),sprite_add("Sprites/Dev Icon/Energized Intestines.png", 1, 12, 16), sprite_add("Sprites/Alt/Energized Intestines.png", 1, 12, 16)]);
lq_set(global.sprites, "Filtering Teeth", [sprite_add("Sprites/Main/Filtering Teeth.png", 1, 12, 16), sprite_add("Sprites/Alt/Filtering Teeth.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Filtering Teeth.png", 1, 12, 16)]);
lq_set(global.sprites, "Fractured Fingers", [sprite_add("Sprites/Main/Fractured Fingers.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Fractured Fingers.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Fractured Fingers.png", 1, 12, 16), sprite_add("Sprites/Alt/Fractured Fingers.png", 1, 12, 16)]);
lq_set(global.sprites, "Garment Regenerator", [sprite_add("Sprites/Main/Garment Regenerator.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Garment Regenerator.png", 1, 12, 16)]);
lq_set(global.sprites, "Mimicry", [sprite_add("Sprites/Main/Mimicry.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Mimicry.png", 1, 12, 16), sprite_add("Sprites/Alt/Mimicry.png", 1, 12, 16), sprite_add("Sprites/Alt/Mimicry 2.png", 1, 12, 16)]);
lq_set(global.sprites, "Muscle Memory", [sprite_add("Sprites/Main/Muscle Memory.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Muscle Memory.png", 1, 12, 16)]);
lq_set(global.sprites, "Pressurized Lungs", [sprite_add("Sprites/Main/Pressurized Lungs.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Pressurized Lungs.png", 1, 12, 16)]);
lq_set(global.sprites, "Rocket Casings", [sprite_add("Sprites/Main/Rocket Casings.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Rocket Casings.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Rocket Casings.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Rocket Casings 2.png", 1, 12, 16)]);
lq_set(global.sprites, "Sadism", [sprite_add("Sprites/Main/Sadism.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Sadism.png", 1, 12, 16), sprite_add("Sprites/Alt/Sadism.png", 1, 12, 16)]);
lq_set(global.sprites, "Scrap Arms", [sprite_add("Sprites/Main/Scrap Arms.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Scrap Arms.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Scrap Arms.png", 1, 12, 16)]);
lq_set(global.sprites, "Shattered Skull", [sprite_add("Sprites/Main/Shattered Skull.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Shattered Skull.png", 1, 12, 16)]);
lq_set(global.sprites, "Shocked Skin", [sprite_add("Sprites/Main/Shocked Skin.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Shocked Skin.png", 1, 12, 16), sprite_add("Sprites/Alt/Shocked Skin.png", 1, 12, 16)]);
lq_set(global.sprites, "Sloppy Fingers", [sprite_add("Sprites/Main/Sloppy Fingers.png", 1, 12, 16), sprite_add("Sprites/Alt/Sloppy Fingers.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Sloppy Fingers.png", 1, 12, 16)]);
lq_set(global.sprites, "Staked Chest", [sprite_add("Sprites/Main/Staked Chest.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Staked Chest.png", 1, 12, 16)]);
lq_set(global.sprites, "Steel Nerves", [sprite_add("Sprites/Main/Steel Nerves.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Steel Nerves.png", 1, 12, 16)]);
lq_set(global.sprites, "Thick Head", [sprite_add("Sprites/Main/Thick Head.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Thick Head.png", 1, 12, 16)]);
//lq_set(global.sprites, "Toxic Thoughts", [sprite_add("Sprites/Main/Toxic Thoughts.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Toxic Thoughts.png", 1, 12, 16), sprite_add("Sprites/Alt/Toxic Thoughts.png", 1, 12, 16)]);
//lq_set(global.sprites, "Unstable DNA", [sprite_add("Sprites/Main/Unstable DNA.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Unstable DNA.png", 1, 12, 16)]);
lq_set(global.sprites, "Waste Gland", [sprite_add("Sprites/Main/Waste Gland.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Waste Gland.png", 1, 12, 16)]);
lq_set(global.sprites, "Loner", [sprite_add("Sprites/Main/Loner.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Loner.png", 1, 12, 16)]);
lq_set(global.sprites, "Neural Network", [sprite_add("Sprites/Main/Neural Network.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network.png", 1, 12, 16)]);
lq_set(global.sprites, "Deep Convolutional Network", [sprite_add("Sprites/Main/Neural Network/Deep Convolutional Network.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Deep Convolutional Network.png", 1, 12, 16)]);
lq_set(global.sprites, "Deep Residual Network", [sprite_add("Sprites/Main/Neural Network/Deep Residual Network.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Deep Residual Network.png", 1, 12, 16)]);
lq_set(global.sprites, "Echo State Network", [sprite_add("Sprites/Main/Neural Network/Echo State Network.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Echo State Network.png", 1, 12, 16)]);
lq_set(global.sprites, "Feed Forward Network", [sprite_add("Sprites/Main/Neural Network/Feed Forward Network.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Feed Forward Network.png", 1, 12, 16)]);
lq_set(global.sprites, "Generative Adversarial Network", [sprite_add("Sprites/Main/Neural Network/Generative Adversarial Network.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Generative Adversarial Network.png", 1, 12, 16)]);
lq_set(global.sprites, "Markov Chain", [sprite_add("Sprites/Main/Neural Network/Markov Chain.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Markov Chain.png", 1, 12, 16)]);
lq_set(global.sprites, "Recurrent Neural Network", [sprite_add("Sprites/Main/Neural Network/Recurrent Neural Network.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Recurrent Neural Network.png", 1, 12, 16)]);
lq_set(global.sprites, "Support Vector Machines", [sprite_add("Sprites/Main/Neural Network/Support Vector Machines.png", 1, 12, 16), sprite_add("Sprites/Dev Icon/Neural Network/Support Vector Machines.png", 1, 12, 16)]);

lq_set(global.sprites, "Fast Food", [sprite_add("Sprites/Main/Ultras/Fast Food.png", 1, 12, 16), {icon:sprite_add("Sprites/Alt/Ultras/Fast Food.png", 1, 12, 16),anim:sprite_add("Sprites/Ultras/Fast Food Anim.png", 11, 21, 26)}, sprite_add("Sprites/Alt/Ultras/Fast Food.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Fast Food 2.png", 1, 12, 16)]);
lq_set(global.sprites, "Intellect", [sprite_add("Sprites/Main/Ultras/Intellect.png", 1, 12, 16), sprite_add("Sprites/Dev Art/Ultras/Intellect.png", 1, 12, 16)]);
lq_set(global.sprites, "Galactic Style", [sprite_add("Sprites/Main/Ultras/Galactic Style.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Galactic Style.png", 1, 12, 16)]);
lq_set(global.sprites, "Armory", [sprite_add("Sprites/Main/Ultras/Armory.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Armory.png", 1, 12, 16)]);
lq_set(global.sprites, "Generalist", [sprite_add("Sprites/Main/Ultras/Generalist.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Generalist.png", 1, 12, 16)]);
lq_set(global.sprites, "Union", [sprite_add("Sprites/Main/Ultras/Union.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Union.png", 1, 12, 16)]);
lq_set(global.sprites, "Existence", [sprite_add("Sprites/Main/Ultras/Existence.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Existence 2.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Existence.png", 1, 12, 16)]);
lq_set(global.sprites, "Reincarnation", [sprite_add("Sprites/Main/Ultras/Reincarnation.png", 1, 12, 16), sprite_add("Sprites/Alt/Ultras/Reincarnation.png", 1, 12, 16)]);

lq_set(global.sprites, "Laser Focus", [sprite_add("Sprites/Outcast/Laser Focus.png", 1, 12, 16), sprite_add("Sprites/Outcast/Alt/Laser Focus.png", 1, 12, 16)]);
lq_set(global.sprites, "Cruelty-Free Veganlust", [sprite_add("Sprites/Outcast/Cruelty-Free Veganlust.png", 1, 12, 16), sprite_add("Sprites/Outcast/Alt/Cruelty-Free Veganlust.png", 1, 12, 16)]);
lq_set(global.sprites, "Iron Skin", [sprite_add("Sprites/Outcast/Iron Skin.png", 1, 12, 16), sprite_add("Sprites/Outcast/Alt/Iron Skin.png", 1, 12, 16)]);
lq_set(global.sprites, "Bursted Chest", [sprite_add("Sprites/Outcast/Bursted Chest.png", 1, 12, 16), sprite_add("Sprites/Outcast/Alt/Bursted Chest.png", 1, 12, 16)]);
lq_set(global.sprites, "Groupthink", [sprite_add("Sprites/Outcast/Groupthink.png", 1, 12, 16), sprite_add("Sprites/Outcast/Alt/Groupthink.png", 1, 12, 16)]);

// lq_set(global.sprites, "Terrorism", [sprite_add("Sprites/Blights/Terrorism.png", 1, 12, 16), sprite_add("Sprites/Blights/Alt/Terrorism.png", 1, 12, 16)]);

global.spriteChoices = {}
wait(file_load("MutArt.txt"));
var s = string_load("MutArt.txt");
if(is_string(s) && s != ""){
	global.spriteChoices = json_decode(s);
}
for(var i = 0; i < lq_size(global.sprites); i++){
	changeArt(lq_get_key(global.sprites, i), 0);
}

chat_comp_add("mutart", "opens the Mutation Art menu");
chat_comp_add("mutartname", "Changes the mutation art for the typed LOMuts mutation");
wait(20);
trace("Type /mutart to bring up a menu to change mutation art!");

#define chat_command
if (argument0 == "mutart"){
	with(mod_script_call_nc("mod", "GuiPack", "gp_create_object", "gp_window", "LOMuts Art")){
		x = 80;
		y = 50;
		w = 150;
		h = 150;
		name = "LOMuts Art";
		colorH = make_color_rgb(90,90,90);
		color = make_color_rgb(70,70,70);
		colorIH = make_color_rgb(40,40,40);
		bgColor = make_color_rgb(10,10,20);
		bannerColorHighlight = c_purple;
		bannerColor = make_color_rgb(100,0,180);
		gpmarkup = [];
		on_close = script_ref_create(cleanup);
		var _scr = script_ref_create(buttonHover);
		var _scr2 = script_ref_create(buttonStep);
		var _scr3 = script_ref_create(buttonClick);
		var _scr4 = script_ref_create(buttonSprite);
		array_push(gpmarkup, mod_script_call_nc("mod", "GuiPack", "gpsurf_ticker_setup", " Click on a mutation button to change the art! This change persists through reloads. ", 1));
		for(var i = 0; i < lq_size(global.sprites); i++){
			var b = mod_script_call_nc("mod", "GuiPack", "gpsurf_obj_setBorder", 
						mod_script_call_nc("mod", "GuiPack", "gpsurf_obj_setSameLine", 
							mod_script_call_nc("mod", "GuiPack", "gpsurf_button_setup", global.sprites.Sadism[0], 0)
						), 
					2, 2, 2, 2);
			b.hoverText = lq_get_key(global.sprites, i);
			b.hoverScr = _scr;
			b.stepScr = _scr2;
			b.clickScr = _scr3;
			b.spriteScr = _scr4;
			b.hover = -1;
			b.animated = false;
			array_push(gpmarkup, b);
		}
	}
	return true;
}
if (argument0 == "mutartname"){
	if(string(real(argument1)) == argument1){
		changeArt(real(argument1), 1);
	}else{
		changeArt(argument1, 1);
	}
	return true;
}

#define buttonSprite
	if(is_real(argument1.hoverText)){
		argument1.subimg = argument1.hoverText;
		argument1.mutNum = argument1.hoverText;
		argument1.hoverText = skill_get_name(argument1.hoverText);
		return sprSkillIcon;
	}
	if("mutNum" in argument1 && is_real(argument1.mutNum)){
		argument1.subimg = argument1.mutNum;
		return sprSkillIcon;
	}
	var spr = lq_get(global.sprites, argument1.hoverText)[lq_get(global.spriteChoices, argument1.hoverText)];
	if(is_object(spr)){
		if(lq_defget(spr, "anim", noone) != noone){
			argument1.animated = true;
			return spr.anim;
		}
		return spr.icon;
	}
	return spr;

#define buttonHover
	if(argument1.animated){
		argument1.subimg += 0.4;
	}
	if(argument1.hover <= 0){
		x += 1;
		y += 1;
	}
	argument1.hover = 2;

#define buttonStep
	argument1.hover--;
	if(argument1.hover == 0){
		if(argument1.animated){
			argument1.subimg = 0;
		}
		x -= 1;
		y -= 1;
	}

#define buttonClick
	if("mutNum" in argument1 && is_real(argument1.mutNum)){
		changeArt(argument1.mutNum, 1);
	}else{
		changeArt(argument1.hoverText, 1);
	}

#define changeArt(_name, _amount)
with(instances_matching([SkillIcon, EGSkillIcon], "LOMutsAnimCheck", true)){LOMutsAnimCheck = false;}
var _spr = lq_defget(global.spriteChoices, _name, 0)
var _sprites = lq_defget(global.sprites, _name, [])
if(string(real(_name)) == string(_name) && array_length(_sprites) > 0){
	lq_set(global.spriteChoices, _name, (_spr + _amount + array_length(_sprites)) % array_length(_sprites));
	if(_sprites[lq_get(global.spriteChoices, _name)] == ""){
	}else if(_sprites[lq_get(global.spriteChoices, _name)] == "reset"){
		lq_set(global.spriteChoices, _name, (_spr + _amount + 1 + array_length(_sprites)) % array_length(_sprites));
		sprite_restore(sprSkillIcon);
		for(var i = 0; i < sprite_get_number(sprSkillIcon); i++){
			if(i != _name && array_length(lq_defget(global.sprites, i, [])) > 0){
				changeArt(i, 0);
			}
		}
	}else{
		sprite_replace_image(sprSkillIcon, _sprites[lq_get(global.spriteChoices, _name)], _name, 12, 16);
		//I need to replace mutNone to fix the hitbox
		sprite_replace_image(sprSkillIcon, "Sprites/Extras/mutNone.png", 0, 12, 16);
	}
}else if(mod_exists("skill", _name) && array_length(_sprites) > 0){
	mod_variable_set("skill", _name, "sprSkillAnim", noone);
	lq_set(global.spriteChoices, _name, (_spr + _amount + array_length(_sprites)) % array_length(_sprites));
	if(is_object(_sprites[_spr])){
		if(lq_defget(_sprites[_spr], "icon", noone) != noone){
			mod_variable_set("skill", _name, "sprSkillIcon", _sprites[_spr].icon);
		}
		if(lq_defget(_sprites[_spr], "hud", noone) != noone){
			mod_variable_set("skill", _name, "sprSkillHUD", _sprites[_spr].hud);
		}
		if(lq_defget(_sprites[_spr], "anim", noone) != noone){
			mod_variable_set("skill", _name, "sprSkillAnim", _sprites[_spr].anim);
		}
	}else{
		mod_variable_set("skill", _name, "sprSkillIcon", _sprites[_spr]);
	}
}
//else {
// 	trace(_name + " does not have art to change. Did you type it correctly? (caps and spaces matter)");
// }
string_save(json_encode(global.spriteChoices), "MutArt.txt");

#define step
with(instances_matching_ne([SkillIcon, EGSkillIcon], "LOMutsAnimCheck", true)){
	LOMutsAnimCheck = true;
	if(is_string(skill) && mod_variable_exists("skill", skill, "sprSkillAnim") && mod_variable_get("skill", skill, "sprSkillAnim") != noone){
		with(instance_create(x,y,CustomObject)){
			name = "LOMSkillAnim";
			skill = other;
			sprite_index = mod_variable_get("skill", other.skill, "sprSkillAnim");
			image_speed = 0.4;
			image_alpha = 0;
		}
	}
}

#define draw_gui
with(instances_matching(CustomObject, "name", "LOMSkillAnim")){
	if(instance_exists(skill)){
		if(skill.addy <= 0){
			if((image_index + image_speed >= image_number) || (image_index + image_speed < 0)){
				image_speed = 0;
				image_index = image_number - 1;
			}
			x = skill.x;
			y = skill.y - 1 - skill.addy;
			image_alpha = 1;
			draw_self();
			image_alpha = 0;
		}else{
			image_speed = 0.4;
			image_index = 0;
		}
	}else{
		instance_destroy();
	}
}

#define cleanup
string_save(json_encode(global.spriteChoices), "MutArt.txt");