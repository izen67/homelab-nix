{ config, pkgs, ... }:

{
  # NOT working, at least on version 351

  services.cockpit = {
    enable = true;
    port = 9090;       
    openFirewall = true;

    settings = {
      WebService = {
        MaxStartups = 10;
        AllowUnencrypted = true;
      };
      Session = {
        IdleTimeout = 30; # minutes
      };
    };
  };
}
