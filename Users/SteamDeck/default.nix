{ ... }:

{
 isoImage.isoBaseName = "Vontoo_SteamDeck";

 jovian = {
   hardware.has.amd.gpu = true;
   steam.enable         = false;

   devices.steamdeck = {
     enable     = true;
     autoUpdate = true;
   };
 };
}
