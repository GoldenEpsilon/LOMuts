//FULL CREDIT TO THE PASSIVES AS MUTATIONS MOD
//Passives as Mutations by SPG: https://spg.itch.io/passives-as-mutations

#define init
global.stacks = 0;
global.extrastacks = 0;
global.target=global.stacks + global.extrastacks + 4 + 1;
/*if(!file_loaded("settings.txt")){wait file_load("settings.txt");}
var s = string_load("settings.txt");
if(is_string(s) && is_real(real(s))){
	global.stacks = real(s);
}*/
global.timer = 0;
global.stackSet = 0;

chat_comp_add("extramuts", "sets the number of extra mutation choices");
wait(18);
//trace("Extra mutation options: " + string(global.stacks));
//trace("Use /extramuts [value] to set the number of extra mutation choices");

#define game_start
	global.extrastacks = 0;

#define chat_command(command, parameter, player)
if(command == "extramuts"){
	if(string_length(parameter) < 1 || !is_real(real(parameter))){
		trace("invalid parameter. Number needed.");
	}else if(real(parameter) < 0){
		trace("invalid parameter. Needs to be 0 or greater.");
	}else{
		global.stacks = real(parameter);
		trace("Extra mutation options: " + string(global.stacks));
		string_save(parameter, "settings.txt");
	}
	return 1;
}

#define step
//Grillskills compat (turn off extra mutation options if grillskills is enabled
if(!("mutation_animation" in LevCont)){
	if(instance_exists(LevCont) && !instance_exists(CrownIcon) && !instance_exists(EGSkillIcon)){
		if(global.stackSet == 0 || array_length(instances_matching(SkillIcon, "extramuts", 1)) == 0){
			global.target=global.stacks + global.extrastacks + LevCont.maxselect + 1;
		
			global.stackSet = 1;
		}
	}else{
		global.stackSet = 0;
	}

	if instance_exists(SkillIcon) && (!is_string(SkillIcon.skill) || !mod_script_exists("skill", SkillIcon.skill, "skill_avail") || mod_script_call("skill", SkillIcon.skill, "skill_avail")) && !instance_exists(EGSkillIcon) && LevCont.maxselect > 2 {

		if(global.timer < 10){
			global.timer++;
			exit;
		}

		var sis=instance_number(SkillIcon)

		var modifier = 0;
		
		with SkillIcon{
			if(is_string(skill) && mod_script_exists("skill", skill, "skill_reusable") && mod_script_call("skill", skill, "skill_reusable")){
				modifier += 1;
			}
		}

		if sis<global.target + modifier && sis >= 4 && skill_decide() != -1 {
		
			with instance_create(0,0,SkillIcon){
				bonusbutton=1
				p = 0
				skill=0
				tskill = skill_decide();
				while(array_length_1d(instances_matching(SkillIcon,"skill",tskill)) > 0 || skill_get(tskill) > 0 || !skill_get_active(tskill)){
					tskill = skill_decide();
				}
				skill=tskill
				
				num = 1//instance_number(SkillIcon)/1.25 - global.target/4
				creator = LevCont
				//visible = 1 //most important bit, its invisble by default
				name  = skill_get_name(skill)
				if is_real(skill){
					if(skill >= 0){
						sprite_index = sprSkillIcon
						image_index = skill
						text = skill_get_text(skill);
					}
				}else{
					mod_script_call("skill",skill,"skill_button")
					text = mod_script_call("skill",skill,"skill_text")
				}
			}
			
			global.temp=0
			with SkillIcon{
				place=(instance_number(SkillIcon)-global.temp)
				num = (instance_number(SkillIcon)-1-global.temp)/*place/(1+1/global.target)-global.target/3*/

				global.temp+=1
			}

		}
		with SkillIcon{
			extramuts = 1;
			if("bonusbutton" in self && bonusbutton == 1){
				with(LevCont){maxselect = instance_number(SkillIcon)-1;}
			}
			if variable_instance_exists(self,"place")
				with instances_matching(SkillIcon,"place",place-1)
					if visible
						other.visible=1
		
		}
	}else{
		global.timer = 0;
	}
}

	//thank you squiddy

#define skill_get_avail(_skill)
	if (((is_real(_skill) && floor(_skill) == _skill) || (is_string(_skill) && mod_exists("skill", _skill))) && skill_get_active(_skill)){
		if (_skill != mut_heavy_heart || skill_get(mut_heavy_heart) != 0 || (GameCont.wepmuts >= 3 && !GameCont.wepmuted)){
			if (!is_string(_skill) || !mod_script_exists("skill", _skill, "skill_avail") || mod_script_call("skill", _skill, "skill_avail")){
				return true;
			}
		}
	}

	else if (is_string(_skill)){
		if (mod_script_exists("mod", "fake skills", "fake_skill_get_avail") && mod_script_call("mod", "fake skills", "fake_skill_get_avail", _skill)){
			return true;
		}
	}

	return false;

#define skill_get_list
/// skill_get_list(_list, _avail = true)
var _list = argument[0];
var _avail = argument_count > 1 ? argument[1] : true;
if (ds_list_valid(_list)){
	var _skills = [];
	
	for (var i = 1; 29 >= i; i ++){
		array_push(_skills, i);
	}
	
	var _count = array_length(_skills);
	
	var _modded = mod_get_names("skill");
	var _mcount = array_length(_modded);
	array_copy(_skills, _count, _modded, 0, _mcount);
	
	_count += _mcount;
	
	ds_list_clear(_list);
	
	for (var i = 0; _count > i; i ++){
		var _skill = _skills[i];
		
		if ((!_avail || skill_get_avail(_skill)) && (!is_string(_skill) || !mod_script_exists("skill", _skill, "skill_ultra"))){
			ds_list_add(_list, _skill);
		}
	}
	
	if (mod_script_exists("mod", "fake mutations", "fake_skill_get_list")){
		var fake_list = ds_list_create();
		
		mod_script_call("mod", "fake mutations", "fake_skill_get_list", fake_list, _avail, _avail);
		
		var fake_array = ds_list_to_array(fake_list);
		
		ds_list_destroy(fake_list);
		ds_list_add_array(_list, fake_array);
	}
	
	return ds_list_size(_list);
}

throw(`invalid argument0 for skill_get_list${chr(10) + "    "}expected a ds_list, got ${_list}`);

#define skill_decide
/// skill_decide(_avail = true, _button = true)
var _avail = argument_count > 0 ? argument[0] : true;
var _button = argument_count > 1 ? argument[1] : true;
var _list = ds_list_create();
var _count = skill_get_list(_list, _avail);

var _skills = [];

var iris_found = false;

for (var i = 0; _count > i; i ++){
	var _skill = _list[| i];
	
	if (!iris_found && (_skill == "prismatic iris" || _skill == "prismaticiris")){
		iris_found = true;
		
		if (!_button){
			continue;
		}
	}
	
	if (skill_get(_skill) == 0 && (!_button || array_length(instances_matching(SkillIcon, "skill", _skill)) <= 0)){
		if (_button && is_string(_skill) && (mod_exists("skill", _skill) && (string_pos("irisslave", _skill) == 1 || (is_string(mod_script_call("skill", _skill, "skill_iris")) && string_length(mod_script_call("skill", _skill, "skill_iris")))) > 0)){
			continue;
		}
		
		else{
			array_push(_skills, _skill);
		}
	}
}

ds_list_destroy(_list);

var _length = array_length(_skills);

return (_length > 0 ? _skills[irandom(_length - 1)] : -1);