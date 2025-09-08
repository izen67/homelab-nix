{ config, pkgs, ... }:

{
  # LTS kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # --- Generic Packages ---
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    nmap
    inetutils
    usbutils
    dnsutils
    pciutils
    mesa-demos
    gnupg
    openssl
    jq
  ];

  # --- Basics ---
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";
  
  # --- Common admin user ---
  users.users.globaladmin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # sudo rights
    hashedPassword = "$2b$05$S6e6lrNvGYYi1ME590YHA.qEoC.g8qH2RqtGrNag8eX5fKCH4/zsy";
  };

  # --- SSH ---
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = true; # since you want password logins
  };

  # --- Sudo ---
  security.sudo.wheelNeedsPassword = false; # allows `sudo` without typing password

  # --- Nix housekeeping ---
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings.auto-optimise-store = true;

  # --- Timezone ---
  time.timeZone = "Europe/Bucharest";
}
