{ lib
, pkgs
, config
, modulesPath
, ...
}:

let
 inherit (lib)
  mkDefault;

 inherit (pkgs)
  writeScriptBin;

 start = writeScriptBin "start" ''
    lsblk_device_sda=$(lsblk -n -d -I 8 -o NAME)
    lsblk_device_nvme=$(lsblk -n -d -I 259 -o NAME)

    lsblk_device_sda_size=$(lsblk -n -d -I 8 -o SIZE)
    lsblk_device_nvme_size=$(lsblk -n -d -I 259 -o SIZE)

    link_disko="github:nix-community/disko"
    link_disk_setup="https://raw.githubusercontent.com/Vonixxx/Vontoo/main/System/Configuration/Disk/default.nix"

    nmtui connect
    clear

    curl "$link_disk_setup" -o /tmp/disk.nix

    selected_disk=$(zenity --list \
     --title="Select Disk" \
     --column="Disk Name" --column="Disk Size" \
       $lsblk_device_sda $lsblk_device_sda_size \
       $lsblk_device_nvme $lsblk_device_nvme_size)

    if [ -n "$selected_disk" ]; then
     sudo nix run "$link_disko" -- --mode disko /tmp/disk.nix --argstr device "/dev/$selected_disk"
    else
     echo "No disk selected"
    fi

    profile=$(zenity --entry \
     --title="Select Profile" \
     --text="Last name's initial followed by your first name, as such:" \
     --entry-text "Richard Nixon -> N_Richard")

    if [ -n "$profile" ]; then
     sudo nix-shell -p nixVersions.latest --run 'nixos-install --root /mnt --no-root-passwd --flake github:Vonixxx/Vontoo#'"$profile"
    else
     echo "No profile selected"
    fi

    reboot
 '';
in {
 imports = [
   (modulesPath + "/installer/cd-dvd/iso-image.nix")
 ];

 system.stateVersion = "24.11";

 environment = {
   gnome.excludePackages = with pkgs; [
     gnome-tour
   ];

   systemPackages = with pkgs; with gnome; [
     git
     ghc
     helix
     start
     zenity
   ];
 };

 boot.kernelParams = [
   "quiet"
 ];

 nix.settings.experimental-features = [
   "flakes"
   "nix-command"
 ];

 hardware = {
   enableRedistributableFirmware = true;

   bluetooth = {
     enable      = true;
     powerOnBoot = true;
   };
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

 services = {
   displayManager.autoLogin = {
     enable = true;
     user   = "VontooInstall";
   };

   xserver = {
     enable                      = true;
     displayManager.gdm.enable   = true;
     desktopManager.gnome.enable = true;

     excludePackages = [
       pkgs.xterm
     ];
   };
 };

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
   isoBaseName         = mkDefault "Vontoo_Vanilla";
   squashfsCompression = "gzip -Xcompression-level 1";
   isoName             = "${config.isoImage.isoBaseName}.iso";
 };
}
