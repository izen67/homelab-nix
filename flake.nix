{
  description = "NixOS configs for my VMs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
};

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {

      bmax = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./base/default.nix
          ./services/default.nix
        ];
      };

    };
  };
}
