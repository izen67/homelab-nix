{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "server";
    extraSetFlags = [
      "--advertise-routes=192.168.50.0/24"
      "--advertise-exit-node"
    ];
    # Disable telemetry / support logs
    extraDaemonFlags = [
      "--no-logs-no-support"
    ];
  };
}
