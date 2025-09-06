{ config, pkgs, ... }:

{
  imports = [ ../hosts/proxmox/hardware-configuration.nix ]; # Import hardware-configuration, its the same for all VMs, so its universal

  # --- Bootloader. ---
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # --- QEMU Guest Agent ---
  services.qemuGuest.enable = true;

  # --- Network ---
  networking.firewall.enable = false;
}
