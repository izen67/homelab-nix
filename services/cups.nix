{ config, pkgs, ... }:

{
  networking.hostName = "cups";

  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "@LOCAL" ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.enable = true;
    publish.userServices = true;
  };

  # Add user to fix web interface permissions
  users.users.globaladmin.extraGroups = [ "lp" "lpadmin" ];
}
