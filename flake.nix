{
  description = "NixOS configs for my VMs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
};

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {

      # Example configs

      cups-bmax = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-bmax.nix
          ./modules/common.nix
          ./services/cups.nix
        ];
      };

      caddy-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-vm.nix
          ./modules/common.nix
          ./services/caddy.nix
        ];
      };

      searxng-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-vm.nix
          ./modules/common.nix
          ./services/searxng.nix
        ];
      };

      wikijs-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-vm.nix
          ./modules/common.nix
          ./services/wikijs.nix
        ];
      };


      wireguard-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-vm.nix
          ./modules/common.nix
          ./services/wireguard.nix
        ];
      };


      samba-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-vm.nix
          ./modules/common.nix
          ./services/samba.nix
        ];
      };


      zoneminder-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-vm.nix
          ./modules/common.nix
          ./services/zoneminder.nix
        ];
      };

      jellyfin-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/base-vm.nix
          ./modules/common.nix
          ./services/jellyfin.nix
        ];
      };

    };
  };
}
