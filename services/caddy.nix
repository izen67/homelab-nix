{ config, pkgs, lib, ... }:

{
  networking.hostName = "caddy";

# Needed packages:
  environment.systemPackages = with pkgs; [
    util-linux # Needed for Logger (ddclient):
    ddclient
    socat
  ];

# Start Caddy
  services.caddy = {
      enable = true;
      package = pkgs.caddy;
    
      configFile = pkgs.writeText "Caddyfile" ''
        {
          email begiy82444@futurejs.com
          log {
            output file /var/log/caddy/access.log
            format json
          }
        }
    
        import sites/*
      '';
   };

# Enable ddclient
  services.ddclient = {
    enable = true;
    package = pkgs.ddclient;
    configFile = "/etc/secrets/ddclient.conf";
  };

# Socat to be able to open port for the minecraft vm from this vm
  systemd.services.socat-minecraft = {
  description = "Socat TCP Relay to Minecraft VM";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
      ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:25565,reuseaddr,fork TCP:192.168.50.105:25565";
      Restart = "always";
      RestartSec = 2;
      User = "nobody";
      };
  };

# Socat to be able to open port for the wireguard vm from this vm
  systemd.services."socat-wireguard" = {
  description = "Socat UDP Relay to WireGuard VM";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    ExecStart = "${pkgs.socat}/bin/socat UDP-LISTEN:52921,reuseaddr,fork UDP:192.168.50.198:52921";
    Restart = "always";
    RestartSec = 2;
    User = "nobody";
    };
  };


#-------------------------------------------------------------------------------------------------------------
# Add .caddy files for sites here
#-------------------------------------------------------------------------------------------------------------
  # Jellyfin site
  environment.etc."caddy/sites/jellyfin.caddy".text = ''
    watch.normiecorner.gay {
        reverse_proxy http://192.168.50.104:8096

        log {
            output file /var/log/caddy/watch.log
            format json
        }
    }
  '';

  # Searxng site
  environment.etc."caddy/sites/searxng.caddy".text = ''
    search.ts-pmo.lol {
        reverse_proxy 192.168.50.106:8888
        encode gzip
        header {
          Referrer-Policy "no-referrer"
          X-Content-Type-Options "nosniff"
          X-Frame-Options "DENY"
          X-Robots-Tag "noindex, nofollow"
        }
        log {
          output file /var/log/caddy/search.log
          format json
        }
      }
  '';

  # Wiki-JS site
  environment.etc."caddy/sites/wiki.caddy".text = ''                                                                               
    wiki.ts-pmo.lol {
        reverse_proxy 192.168.50.102:3000
        log {
          output file /var/log/caddy/wiki.log
          format json
        }
      }
  '';


}
