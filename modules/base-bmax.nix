{ config, pkgs, ... }:

{
  imports = [ ../hosts/bmax/hardware-configuration.nix ]; # Import hardware-configuration, its the same for all VMs, so its universal

  # --- Bootloader. ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Network ---
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
}
