##########
# Vontoo #
#################
# Installer ISO #
#################
{
 inputs = {
   ##########################
   # Synchronizing Packages #
   ##########################
   jovian.inputs.nixpkgs.follows = "nixpkgs";
   #########################
   # Official Repositories #
   #########################
   nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
   ##########################
   # Community Repositories #
   ##########################
   jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
 };

 outputs = {
   jovian
 , nixpkgs
 , ...
 }:

let
 systemModules = [
   ./System
 ];

 mkSystem = extraOverlays:
            extraModules:
   nixpkgs.lib.nixosSystem rec {
     specialArgs = {
       inherit
       pkgs;
     };

     modules = extraModules
               ++ systemModules;

     pkgs = import nixpkgs {
       config.allowUnfree = true;
       overlays           = extraOverlays;
       system             = "x86_64-linux";
     };
   };
in {
 nixosConfigurations = {
     Vanilla = mkSystem []
                        [];

     SteamDeck = mkSystem [ jovian.overlays.default ]
                          [ jovian.nixosModules.jovian ./System/SteamDeck ];
   };
 };
}
