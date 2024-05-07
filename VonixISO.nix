##########
# Vontoo #
#################
# Installer ISO #
#################
{ pkgs
, ...
}:

let
 inherit (pkgs)
  writeScriptBin;
in {
 boot.kernelParams                  = [ "quiet" ];
 nix.settings.experimental-features = [ "nix-command" "flakes" ];
 imports                            = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];

 networking = {
   networkmanager.enable = true;
   wireless.enable       = false;
 };

 environment.systemPackages = let
  start = writeScriptBin "start" ''
     nmtui connect
     clear
     echo Fetching Script...
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/master/Script/Main.hs         -o ./Main.hs         &> /dev/null &&
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/master/Script/Variables.hs    -o ./Variables.hs    &> /dev/null &&
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/master/Script/Installation.hs -o ./Installation.hs &> /dev/null &&
     curl https://raw.githubusercontent.com/Vonixxx/Vontoo_Install/master/Script/Partitioning.hs -o ./Partitioning.hs &> /dev/null &&
     echo Fetching Script - Successful
     sudo runhaskell ./Main.hs
  '';
 in with pkgs; [
   curl
   ghc
   start
 ];
}
