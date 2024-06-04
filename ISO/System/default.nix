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
   sudo.wheelNeedsPassword = true;
 };

  services = {
    displayManager.autoLogin = {
      enable = true;
      user   = "VontooInstall";
    };

    xserver = {
      enable                      = true;
      gdm.enable                  = true;
      desktopManager.gnome.enable = true;

      excludePackages = [
        pkgs.xterm
      ];
    };
  };

 users.users.vontoo = {
   uid          = 1000;
   isNormalUser = true;
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
   isoBaseName         = "Vontoo.iso";
   squashfsCompression = "gzip -Xcompression-level 1";
   isoName             = "${config.isoImage.isoBaseName}.iso";
 };

 environment.systemPackages = let
  start = writeScriptBin "start" ''
     nmtui connect
     mkdir Haskell
     echo Fetching Script...
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/main/Script/Main.hs         -o ./Haskell/Main.hs         &> /dev/null &&
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/main/Script/Variables.hs    -o ./Haskell/Variables.hs    &> /dev/null &&
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/main/Script/Installation.hs -o ./Haskell/Installation.hs &> /dev/null &&
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/main/Script/Partitioning.hs -o ./Haskell/Partitioning.hs &> /dev/null &&
     echo Fetching Script - Successful.
     sudo runhaskell ./Haskell/Main.hs
  '';
 in with pkgs; [
   curl
   git
   ghc
   helix
   start
 ];
}
