{
  flake.modules.nixos.server = { config, pkgs, secrets, ... }: let
    inherit (config.nimic) domain;
  in {
    age.secrets.nextcloud = {
      file = "${secrets}/nextcloud.age";
      owner = "nextcloud";
      group = "nextcloud";
    };

    services = {
      nextcloud = {
        enable = true;
        package = pkgs.nextcloud33;

        hostName = "cloud.${domain}";
        database.createLocally = true;
        configureRedis = true;
        home = "/mnt/Nextcloud";

        maxUploadSize = "10G";
        https = true;

        extraAppsEnable = true;
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps) calendar news;
        };

        config = {
          dbtype = "mysql";
          adminuser = "admin";
          adminpassFile = config.age.secrets.nextcloud.path;
        };
      };

      nginx.virtualHosts."cloud.${domain}".listen = [
        {
          addr = "127.0.0.1";
          port = 8420;
        }
      ];

      caddy.virtualHosts."cloud.${domain}" = {
        useACMEHost = "${domain}";
        extraConfig = ''
          reverse_proxy 127.0.0.1:8420
          header -Server
        '';
      };
    };
  };
}
