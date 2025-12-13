#define draw_gui
	if(!mod_variable_get("mod", "LOMuts", "showStackIndicator")){
		return;
	}
	var player_count = 0;
	var i = 0;

	for (i = 0; maxp > i; i ++){
		if (player_is_active(i)){
			player_count += 1;
		}
	}
	i = 0;
	var ultra_count = array_length(ultras_get())
	var patience_offset = 0;
	draw_set_font(fntSmall);
	while(skill_get_at(i) != null){
		if(skill_get_at(i) == GameCont.hud_patience){
			patience_offset++;
		}
		var _columns;
		var y_reversed;
		var start_x;
		var start_y;
		switch(player_count){
			case 1:{
				_columns = floor((game_width - 111) div 16);
				y_reversed = 1;
				start_x = game_width - 11;
				start_y = 12;
				
				break;
			}
			
			case 2:{
				_columns = floor((game_width - 11) div 16);
				y_reversed = -1;
				start_x = game_width - 11;
				start_y = game_height - 12;
				start_y -= (instance_exists(mutbutton)) * 34;
				
				break;
			}
			
			case 3:{
				_columns = (instance_exists(mutbutton) ? floor((game_width - 11) div 16) : floor((game_width - 111) div 16));
				y_reversed = -1;
				start_x = game_width - 11;
				start_y = game_height - 12;
				start_y -= (instance_exists(mutbutton)) * 34;
				
				break;
			}
			
			case 4:{
				_columns = (instance_exists(mutbutton) ? floor((game_width - 11) div 16) : floor((game_width - 189) div 16));
				y_reversed = -1;
				start_x = (instance_exists(mutbutton) ? game_width - 11 : game_width - 100);
				start_y = game_height - 12;
				start_y -= (instance_exists(mutbutton)) * 34;
				
				break;
			}
		}
		var offsetx = 16 * ((i + ultra_count - patience_offset) % _columns);
		var offsety = floor((i + ultra_count - patience_offset) / _columns) * 16 * y_reversed;
		var drawn = 0;
		if(real(skill_get(skill_get_at(i))) > 1){
			var drawn = 1;
			draw_text_nt(start_x - 8 - offsetx, 14 + offsety, "@(color:" + string(make_color_rgb(150, 255, 0)) + ")" + string(real(skill_get(skill_get_at(i)))));
		}
		if(!drawn){
			for(j = 0; j < player_count; j++){
				if(point_in_rectangle(mouse_x[j]-view_xview[j],mouse_y[j]-view_yview[j],start_x - 8 - offsetx,offsety,start_x + 8 - offsetx,16 + offsety)){
					draw_text_nt(start_x - 8 - offsetx, 14 + offsety, "@(color:" + string(make_color_rgb(150, 255, 0)) + ")" + string(real(skill_get(skill_get_at(i)))));
				}
			}
		}
		i++;
	}
	draw_set_font(fntM);
	
#define draw_pause

draw_set_projection(0);

draw_gui();

draw_reset_projection();

//adapted from some of Squiddy's code
#define ultras_get()
var modded_races = mod_get_names("race");
var race_count = 17 + array_length(modded_races);
var i = 1;

var u = [];

var _coop = ultra_count(0);

for (i = 1; _coop >= i; i ++){
	if (ultra_get(0, i) != 0){
		array_push(u, {sprite: sprEGIconHUD, image: i - 1, race: race_get_name(0), ultra: i});
	}
}

for (i = 1; race_count > i; i ++){
	var _race = (i <= 16 ? race_get_name(i) : modded_races[i - 17]);
	var u_count = ultra_count(_race);
	var j = 1;
	
	for (j = 1; u_count >= j; j ++){
		if (ultra_get(_race, j) != 0){
			array_push(u, [_race, j]);
		}
	}
}

return u;