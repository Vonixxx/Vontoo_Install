{ pkgs
, config
, modulesPath
, ...
}:

let
 inherit (pkgs)
  writeScriptBin;
in {
 imports = [
   (modulesPath + "/installer/cd-dvd/iso-image.nix")
 ];

 system.stateVersion = "24.11";

 boot.kernelParams = [
   "quiet"
 ];

 zramSwap = {
   memoryPercent = 100;
   enable        = true;
 };

 nix.settings.experimental-features = [
   "flakes"
   "nix-command"
 ];

 hardware.bluetooth = {
   enable      = true;
   powerOnBoot = true;
 };

 networking = {
   networkmanager.enable = true;
   wireless.enable       = false;
 };

 security = {
   rtkit.enable            = true;
   polkit.enable           = true;
   sudo.wheelNeedsPassword = false;
 };

#  services = {
#    displayManager.autoLogin = {
#      enable = true;
#      user   = "VontooInstall";
#    };
#
#    xserver = {
#      enable                      = true;
#      displayManager.gdm.enable   = true;
#      desktopManager.gnome.enable = true;
#
#      excludePackages = [
#        pkgs.xterm
#      ];
#    };
#  };

 users.users.vontoo = {
   uid          = 1000;
   isNormalUser = true;
   password     = "111";
   name         = "VontooInstall";
   home         = "/home/VontooInstall";

   extraGroups  = [
     "audio"
     "video"
     "wheel"
     "networkmanager"
   ];
 };

 isoImage = {
   makeEfiBootable     = true;
   makeUsbBootable     = true;
   isoBaseName         = "Vontoo";
   squashfsCompression = "gzip -Xcompression-level 1";
   isoName             = "${config.isoImage.isoBaseName}.iso";
 };

 environment.systemPackages = let
  start = writeScriptBin "start" ''
     nmtui connect

     echo Fetching Script...
     git clone https://github.com/Vonixxx/Vontoo_Install
     sleep 3
     echo Fetching Script - Successful.

     cd ./Vontoo_Install/Script
     sudo runhaskell ./Main.hs
  '';
 in with pkgs; [
   git
   ghc
   helix
   start
 ];
}
