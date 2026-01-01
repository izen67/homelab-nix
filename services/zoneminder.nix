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

  # Samba login user
  users.users.sambazm = {
    isNormalUser = true;
    extraGroups = [ "nginx" ];
  };

  # Also allow your main admin user access
  users.users.bmax.extraGroups = [ "nginx" ];

  # Samba share
  services.samba = {
    enable = true;
    openFirewall = true;
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
        "valid users" = [ "@nginx" ]; # allow group members
      };
    };
  };
}
