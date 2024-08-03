##########
# Vontoo #
#################
# Installer ISO #
#################
{
 inputs = {
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
 mkSystem =
 profile:
 extraOverlays:
 extraModules:
 nixpkgs.lib.nixosSystem rec {
   specialArgs = {
     inherit
     pkgs;
   };

   modules = [
    (./Users + profile)
   ] ++ [
    ./Users/Vanilla
   ] ++ extraModules;

   pkgs = import nixpkgs {
     config.allowUnfree = true;
     overlays           = extraOverlays;
     system             = "x86_64-linux";
   };
 };
in {
   nixosConfigurations = (
     import ./Users {
      inherit
       jovian
       mkSystem;
     }
   );
 };
}
