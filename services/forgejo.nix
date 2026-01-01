{ config, pkgs, lib, ... }:

{
  # Setup PostgreSQL
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "forgejo" ];
    ensureUsers = [
      {
        name = "forgejo";
        ensureDBOwnership = true;
      }
    ];
  };

  # Setup Forgejo
  services.forgejo = {
    enable = true;

    database = {
      type = "postgres";
      name = "forgejo";
      user = "forgejo";
    };

    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "bmax";          # or your LAN hostname / IP
        HTTP_PORT = 3000;
        ROOT_URL = "http://forgejo:3000/";
      };

      service = {
        DISABLE_REGISTRATION = true;     # disable public registration after admin creation
      };

      "repository.upload" = {
        ENABLED = true;
        FILE_MAX_SIZE = 5120; # 5 GB
        MAX_FILES = 500;
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];

}
