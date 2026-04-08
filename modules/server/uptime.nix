{
  flake.modules.nixos.server = { config, ... }: {
    services = let
      inherit (config.nimic) domain;
      host = "127.0.0.1";
      port = 3001;
    in {
      uptime-kuma = {
        enable = true;
        settings = {
          "UPTIME_KUMA_HOST" = host;
          "UPTIME_KUMA_PORT" = toString port;
        };
      };

      caddy.virtualHosts."uptime.${domain}" = {
        useACMEHost = "${domain}";
        extraConfig = ''
          reverse_proxy ${host}:${toString port}
          header -Server
        '';
      };
    };
  };
}
