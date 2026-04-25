{ config, pkgs, ... }:

{
  age.secrets.nextcloud = {
    file = /etc/nixos/secrets/nextcloud.age;
    owner = "nextcloud";
    group = "nextcloud";
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;

      hostName = "cloud.heartblin.eu";
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
}
