// Define Sprites
#define init
global.spr_idle = sprite_add("../sprites/crown/sprCrownIdle.png",1,8,8);
global.spr_walk = sprite_add("../sprites/crown/sprCrownWalk.png",6,8,8);
global.spr_icon = sprite_add("../sprites/crown/sprCrownSelect.png",1,12,16);
//Set Sprites
#define crown_object
spr_idle = global.spr_idle;
spr_walk = global.spr_walk;

#define crown_button
sprite_index = global.spr_icon;

#define step
with(instances_matching_ne(enemy, "outcastCrownEffect", 1)){
	outcastCrownEffect = 1;
	if("raddrop" in self && raddrop > 0){
		raddrop++;
	}
}

#define game_start

#define crown_name // Crown Name
return "CROWN OF OUTCASTS";

#define crown_text // Description
return `MORE @gRADS@s#@(color:${make_color_rgb(84, 58, 24)})OUTCAST MUTATIONS@s APPEAR#IN THE MUTATION POOL`;

#define crown_tip // Loading Tip
return "FREAKS COME OUT#UNTIL THE LIGHTS GO ON";

#define crown_avail // L0
if(GameCont.loops == 0) return 1;

#define crown_take
	sound_play_crown()
	mod_variable_set("mod", "LOMuts", "canOutcast", mod_variable_get("mod", "LOMuts", "canOutcast") + 1);

#define crown_lose
	mod_variable_set("mod", "LOMuts", "canOutcast", mod_variable_get("mod", "LOMuts", "canOutcast") - 1);

//taken from crown of exchange
#define sound_play_crown()
with instance_create(0,0,CustomObject)// /gml mod_script_call("crown","exchange","sound_play_crown")
{
sound_play_pitchvol(sndStatueDead,2,.4)
sound_play_pitchvol(sndStatueCharge,.8,.2)
	timer = 0
	on_step = snd_step
	on_cleanup = snd_destroy
}

#define snd_step
timer += current_time_scale
// /gml mod_script_call("crown","exchange","sound_play_crown")
if timer = 1  sound_play_pitchvol(sndCrownLife,1,1)
if timer = 23
{
	sound_set_track_position(sndCrownLife,2)
	sound_play_pitchvol(sndCrownLife,1,1)
}
if timer = 9 sound_play_pitchvol(sndSwapShotgun,.96,1)
if timer = 20 sound_play_pitchvol(sndSwapPistol,.96,1)
if timer = 24 sound_play_pitchvol(sndSwapExplosive,.96,1)
if timer = 30 sound_play_pitchvol(sndSwapEnergy,.96,1)
if timer = 34 sound_play_pitchvol(sndSwapShotgun,.96,1)
if timer = 42 sound_play_pitchvol(sndSwapMachinegun,.96,1)
if timer = 45 sound_play_pitchvol(sndSwapSword,1,1)
if timer >= 100 instance_destroy()

#define snd_destroy
sound_set_track_position(sndCrownLife,0)
