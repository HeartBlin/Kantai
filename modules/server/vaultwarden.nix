{
  flake.modules.nixos.server = { config, ... }: {
    services = let
      inherit (config.nimic) domain;
      host = "127.0.0.1";
      port = 8967;
    in {
      vaultwarden = {
        enable = true;
        backupDir = "/var/local/vaultwarden/backup";
        config = {
          DOMAIN = "https://vault.${domain}";

          ROCKET_ADDRESS = host;
          ROCKET_PORT = toString port;
          ROCKET_LOG = "critical";

          SHOW_PASSWORD_HINT = "false";
          SIGNUPS_ALLOWED = "false";
          INVITATIONS_ALLOWED = "false";
        };
      };

      caddy.virtualHosts."vault.${domain}" = {
        useACMEHost = "${domain}";
        extraConfig = ''
          @denied not remote_ip 100.64.0.0/10 192.168.0.0/16 10.0.0.0/8 172.16.0.0/12
          abort @denied

          reverse_proxy /notifications/hub ${host}:${toString port}
          reverse_proxy ${host}:${toString port}
          header -Server
        '';
      };
    };
  };
}
