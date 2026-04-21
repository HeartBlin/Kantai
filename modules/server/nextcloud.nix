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

        config = {
          dbtype = "mysql";
          adminuser = "admin";
          adminpassFile = config.age.secrets.nextcloud.path;
        };
      };
    };
  };
}
