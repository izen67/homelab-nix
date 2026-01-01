{ config, pkgs, ... }:

{
  # --- Bootloader. ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LTS kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # --- Basics ---
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

  # --- User ---
  users.users.bmax = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # --- Network ---
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.backend = "nftables"
    hostName = "bmax";
  };

  # --- SSH ---
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = true;
  };

  # --- Sudo ---
  security.sudo.wheelNeedsPassword = false;

  # --- Nix housekeeping ---
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
  nix.settings.auto-optimise-store = true;

  # --- Timezone ---
  time.timeZone = "Europe/Bucharest";

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
    btop
    gnupg
    openssl
    gnutls
    jq
  ];
}
