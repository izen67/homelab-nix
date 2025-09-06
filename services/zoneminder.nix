{ config, pkgs, lib, ... }:

{
  networking.hostName = "zoneminder";

  # Needed in case of using NTFS or EXFAT drives
  boot.supportedFilesystems = [ "ntfs" ];
  environment.systemPackages = with pkgs; [
    ntfs3g
    exfatprogs
    cifs-utils
  ];

  # Zoneminder service
  services.zoneminder = {
    enable = true;
    storageDir = "/media/zoneminder"; # DB + metadata
    webserver = "nginx";
    port = 8095;
    database.username = "zoneminder";
    database.createLocally = true;
  };

  # Create sambazm group
  users.groups.sambazm = { };

  # Samba login user
  users.users.sambazm = {
    isNormalUser = true;
    extraGroups = [ "sambazm" ];
  };

  # Make sure zoneminder user belongs to sambazm
  users.users.zoneminder.extraGroups = [ "sambazm" ];

  # Also allow your main admin user access
  users.users.globaladmin.extraGroups = [ "sambazm" ];

  # Mount the SSD with fixed uid/gid to match zoneminder:sambazm
  fileSystems."/media/zoneminder" = {
    device = "UUID=1a63c56a-93fd-4dd8-8c0c-72da899cd005";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
      "nofail"
    ];
  };

  # Ensure directory exists with proper ownership/permissions
  systemd.tmpfiles.rules = [
    "d /media/zoneminder 2770 zoneminder sambazm -"
  ];

  # Samba share
  services.samba = {
    enable = true;
    securityType = "user";
    shares = {
      zoneminder = {
        comment = "Zoneminder SSD";
        path = "/media/zoneminder";
        browseable = true;
        "read only" = false;
        "guest ok" = false;
        "create mask" = "0770";
        "directory mask" = "0770";
        "valid users" = [ "@sambazm" ]; # allow group members
      };
    };
  };
}
