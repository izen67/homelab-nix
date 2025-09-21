{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      mesa
    ];
  };

  # Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    user = "jellyfin";  
    group = "plexshare";  

    # Explicit dirs (defaults are fine, but you can pin them)
    dataDir   = "/var/lib/jellyfin";
    configDir = "/var/lib/jellyfin/config";
    cacheDir  = "/var/cache/jellyfin";
    logDir    = "/var/log/jellyfin";
  };

  # Packages Jellyfin needs (wiki recommends these)
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-ffmpeg
  ];

  # Define the plexshare group
  users.groups.plexshare = { };

  # Ensure jellyfin is also in plexshare
  users.users.jellyfin.extraGroups = [ "plexshare" ];
}
