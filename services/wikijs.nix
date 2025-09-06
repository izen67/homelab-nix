{ config, pkgs, lib, ... }:

{
  networking.hostName = "wikijs";

# Setup postgresql
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "wikijs" ];
    ensureUsers = [
      {
        name = "wikijs";
        ensureDBOwnership = true;
      }
    ];
  };

# Setup wikijs
  services.wiki-js = {
    enable = true;
    settings.db = {
      type = "postgres";
      host = "/run/postgresql";
      db = "wikijs";
      user = "wikijs";
    };
  };

  # Make wiki-js systemd service run as the same user as the Postgres role
  systemd.services.wiki-js.serviceConfig.User = "wikijs";

#For the git backups
#For the Local Repository Path in the WikiJS git backup settings page write "/var/lib/wikijs-repo/repo"
systemd.tmpfiles.rules = [
  # Ensure the repo base dir exists, owned by wikijs
  "d /var/lib/wikijs-repo 0750 wikijs wikijs -"
  # Ensure the nested repo folder exists, also owned by wikijs
  "d /var/lib/wikijs-repo/repo 0750 wikijs wikijs -"
  ];
systemd.services."wiki-js".serviceConfig.ReadWritePaths = [
  "/var/lib/wikijs-repo"
  ];

}
