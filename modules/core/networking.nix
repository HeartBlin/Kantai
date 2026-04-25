{ lib, ... }:

{
  networking = {
    nftables.enable = true;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  boot = {
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
    };
  };

  services = {
    tailscale.enable = true;
    resolved = {
      enable = true;
      settings.Resolve = {
        Domains = "~.";
        DNSOverTLS = "opportunistic";
        DNS = [ ];
        FallbackDNS = [
          "9.9.9.9#dns.quad9.net"
          "149.112.112.112#dns.quad9.net"
          "2620:fe::fe#dns.quad9.net"
          "2620:fe::9#dns.quad9.net"
        ];
      };
    };
  };

  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
}
