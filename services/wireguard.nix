{ config, pkgs, lib, ... }:

{
  networking.hostName = "wireguard";

# Networking stuff for wireguard
  networking.nat.enable = true;
  networking.nat.externalInterface = "ens18";
  networking.nat.internalInterfaces = [ "wg0" ];

# Setup wireguard
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.0.0.1/24" ];
    listenPort = 52921;
    privateKeyFile = "/etc/secrets/wg-private";

    postSetup = ''
      ${pkgs.iptables}/bin/iptables -A FORWARD -i %i -j ACCEPT
      ${pkgs.iptables}/bin/iptables -A FORWARD -o %i -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o ens18 -j MASQUERADE
    '';

    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -D FORWARD -i %i -j ACCEPT
      ${pkgs.iptables}/bin/iptables -D FORWARD -o %i -j ACCEPT
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o ens18 -j MASQUERADE
    '';

    peers = [
      {
        publicKey = "a9nHQST9nUHDQP7UJGJI6Rcn1Zf5kcVT1jSxjNvzYik=";
        allowedIPs = [ "10.0.0.2/32" ];
      }
    ];
  };
}
