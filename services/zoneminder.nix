{ config, pkgs, lib, ... }:

{
  # Zoneminder service
  services.zoneminder = {
    enable = true;
    storageDir = "/var/lib/zoneminder"; # DB + metadata
    webserver = "nginx";
    port = 8095;
    openFirewall = true;
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
  users.users.bmax.extraGroups = [ "sambazm" ];

  systemd.tmpfiles.rules = [
    # Fix ownership/permissions ON THE MOUNTED FS
    "Z /var/lib/zoneminder 2770 root sambazm -"
  ];

  # Samba share
  services.samba = {
    enable = true;
    securityType = "user";
    shares = {
      zoneminder = {
        comment = "Zoneminder";
        path = "/var/lib/zoneminder";
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
