#define init
if(mod_exists("mod", "GuiPack")){exit;}
while(!mod_sideload()){wait 1;}
file_delete("GuiPack.mod.gml");
while (file_exists("GuiPack.mod.gml")) {wait 1;}
file_download("https://raw.githubusercontent.com/GoldenEpsilon/GuiPack/main/GuiPack.mod.gml", "GuiPack.mod.gml");
while (!file_loaded("GuiPack.mod.gml")) {wait 1;}
mod_load("data/"+mod_current+".mod/GuiPack.mod.gml");