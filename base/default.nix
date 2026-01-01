{ config, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./base.nix
  ];
}
