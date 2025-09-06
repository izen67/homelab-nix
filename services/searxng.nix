{ config, pkgs, lib, ... }:

{
  networking.hostName = "searxng";

# Setup user
  users.users.searxng = {
    isSystemUser = true;
    group = "searxng";
    home = "/var/lib/searxng";
    createHome = true;
  };

# Setup group
  users.groups.searxng = {};

# Add searxng and redis 
  environment.systemPackages = with pkgs; [
    searxng
    redis
  ];

# Main config for searxng
  environment.etc."searxng/settings.yml".text = ''
    use_default_settings: true

    general:
      debug: false
      instance_name: "SearXNG"

    search:
      safe_search: 0
      autocomplete: 'google'
      default_lang: "all"
      formats:
        - html
      favicon_resolver: "google"

    server:
      # Key is read from environment variable SEARXNG_SECRET
      limiter: false
      image_proxy: true
      port: 8888
      bind_address: 0.0.0.0
      base_url: https://search.ts-pmo.lol/

    redis:
      url: redis://localhost:6379/0

    engines:
      - name: wikidata
        disabled: true

      - name: wikipedia
        disabled: true

      - name: qwant
        disabled: true

      - name: startpage
        disabled: true

      - name: reddit
        engine: reddit
        shortcut: re
        page_size: 25
        disabled: false
  '';

  # Favicons setup for searxng
  environment.etc."searxng/favicons.toml".text = ''
    [favicons]

    cfg_schema = 1   # config's schema version no.

    [favicons.cache]

    db_url = "/var/cache/searxng/faviconcache.db"  # default: "/tmp/faviconcache.db"
    LIMIT_TOTAL_BYTES = 2147483648                 # 2 GB / default: 50 MB
    # HOLD_TIME = 5184000                            # 60 days / default: 30 days
    # BLOB_MAX_BYTES = 40960                         # 40 KB / default 20 KB
    # MAINTENANCE_MODE = "off"                       # default: "auto"
    # MAINTENANCE_PERIOD = 600                       # 10min / default: 1h
  '';

  # Ensure cache directory exists and belongs to searxng
  systemd.tmpfiles.rules = [
    "d /var/cache/searxng 0755 searxng searxng -"
  ];

# Setup the searxng service
  systemd.services.searxng = {
    description = "SearXNG metasearch engine";
    after = [ "network-online.target" "redis.service" ];
    wants = [ "network-online.target" "redis.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.searxng}/bin/searxng-run -c /etc/searxng/settings.yml";
      Restart = "always";
      User = "searxng";
      WorkingDirectory = "/var/lib/searxng";
      EnvironmentFile = "/etc/secrets/searxng-secret-env";
    };
  };

  # Enable Redis
  services.redis.servers."" = {
    enable = true;
    bind = "127.0.0.1";
    port = 6379;
  };

}
