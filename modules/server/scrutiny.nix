{
  flake.modules.nixos.server = { config, ... }: {
    services = let
      inherit (config.nimic) domain;
      host = "127.0.0.1";
      port = 8067;
    in {
      scrutiny = {
        enable = true;
        collector.enable = true;
        settings.web.listen = {
          inherit host port;
        };
      };

      caddy.virtualHosts."scrutiny.${domain}" = {
        useACMEHost = "${domain}";
        extraConfig = ''
          reverse_proxy ${host}:${toString port}
          header -Server
        '';
      };
    };
  };
}
