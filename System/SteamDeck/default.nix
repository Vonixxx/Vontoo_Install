{ ... }:

{
 isoImage.isoBaseName = "Vontoo_SteamDeck";

 boot.kernelPatches = [
   {
    extraMakeFlags = ["O=/home/Bubinka"];
   }
 ];

 jovian = {
   hardware.has.amd.gpu = true;
   steam.enable         = false;

   devices.steamdeck = {
     enable     = true;
     autoUpdate = true;
   };
 };
}
