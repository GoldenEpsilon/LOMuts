#define init
global.sprButton = sprite_add("../Sprites/Main/Neural Network/" + mod_current + ".png", 1, 12, 16)
global.sprIcon = sprite_add("../Sprites/Icons/Neural Network/" + mod_current + " Icon.png", 1, 8, 8)

#define skill_name
	return "Feed Forward Network";
	
#define skill_text
	return "Energy @wMelee@s weapons#@yrefund@s on @wkill@s";

#define skill_button
	sprite_index = global.sprButton;
	
#define skill_icon
	return global.sprIcon;
	
#define skill_wepspec
	return 1;

#define skill_tip
	return "Fast Feed";
	
#define skill_take
	sound_play(sndMutTriggerFingers)
	skill_set("Neural Network", 0);

#define skill_avail
	return 0;
	
#define skill_neural  
	return true;
	
#define step
with(Player){
	with(instances_matching(instances_matching([EnergySlash, EnergyShank, EnergyHammerSlash], "feedRefund", null),"team",team)){
		if(instance_exists(creator) && creator.object_index == Player){
			feedRefund = 1;
			feedRefundWep = other.wep;
			feedRefundCost = weapon_get_cost(feedRefundWep);
			feedRefundType = weapon_get_type(feedRefundWep);
			feedRefundRem = 0;
		}else{
			feedRefund = 2;
		}
	}
	with(instances_matching(instances_matching([EnergySlash, EnergyShank, EnergyHammerSlash], "feedRefund", 1),"team",team)){
		if(instance_exists(creator) && creator.object_index == Player){
			var _x = x + hspeed + lengthdir_x(sprite_width/4, direction);
			var _y = y + vspeed + lengthdir_y(sprite_width/4, direction);
			with(instances_matching_le(enemy, "my_health", 0)){
				if(abs(x - _x) + abs(y - _y) < sprite_width + sprite_height){
					var val = other.feedRefundCost * skill_get(mod_current) + other.feedRefundRem;
					other.creator.ammo[other.feedRefundType] += floor(val);
					other.feedRefundRem = val - floor(val);
					other.creator.ammo[other.feedRefundType] = min(other.creator.ammo[other.feedRefundType], other.creator.typ_amax[other.feedRefundType]);
					other.feedRefund = 2;
				}
			}
		}else{
			feedRefund = 2;
		}
	}
}