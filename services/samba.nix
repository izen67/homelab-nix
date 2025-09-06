{ config, pkgs, lib, ... }:

{
  networking.hostName = "samba";

  # Needed in case of using NTFS or EXFAT drives
  boot.supportedFilesystems = [ "ntfs" ];
  environment.systemPackages = with pkgs; [
    ntfs3g
    exfatprogs
    cifs-utils
  ];

  # Samba service
  services.samba = {
    enable = true;
    securityType = "user";
    shares = {
      ssd = {
        comment = "USB SSD";
        path = "/media/SSD";
        browseable = true;
        "read only" = false;
        "guest ok" = false;
        "create mask" = "0770";
        "directory mask" = "0770";
        "valid users" = [ "samba" ];
        # Permissions
        "force user" = "root";
        "force group" = "sambashare";
      };
    };
  };

  # Define the sambashare group
  users.groups.sambashare = { };

  # Samba user
  users.users.samba = {
    isNormalUser = true;
    extraGroups = [ "users" "sambashare" ];
  };

  # Ensure main user is also in sambashare
  users.users.globaladmin.extraGroups = [ "sambashare" ];

  # Mount USB SSD
  fileSystems."/media/SSD" = {
    device = "UUID=a1602b23-21dc-418d-a62b-896b997f8a2b"; # adjust UUID
    fsType = "ext4";
    options = [ "defaults" "noatime" "nosuid" "nodev" "noexec" ];
  };

  # Ensure the directory exists with correct ownership & permissions
  systemd.tmpfiles.rules = [
    "d /media/SSD 2770 root sambashare -"
  ];
}

