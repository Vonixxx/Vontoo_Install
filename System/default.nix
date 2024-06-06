{ pkgs
, config
, modulesPath
, ...
}:

let
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
      sudo nix run "$link_disko" -- --mode disko /tmp/disk.nix --arg device "/dev/$selected_disk"
    else
      echo "No disk selected"
    fi

    if zenity --entry \
     --title="Select Profile" \
     --text="Last name's initial followed by your first name, as such:" \
     --entry-text "Richard Nixon -> N_Richard"
       then nix-shell -p nixVersions.latest --run 'nixos-install --root /mnt --no-root-passwd --flake github:Vonixxx/Vontoo#$?'
       else echo "No name selected"
    fi
 '';
in {
 imports = [
   (modulesPath + "/installer/cd-dvd/iso-image.nix")
 ];

 system.stateVersion = "24.11";

 environment.systemPackages = with pkgs; with gnome; [
   git
   ghc
   helix
   start
   zenity
 ];

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
   isoBaseName         = "Vontoo";
   squashfsCompression = "gzip -Xcompression-level 1";
   isoName             = "${config.isoImage.isoBaseName}.iso";
 };
}
