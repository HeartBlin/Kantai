{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (config.Kantai) asus;
in {

  config = mkIf asus.enable {
    services = {
      supergfxd.enable =  true;
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };

    systemd.services.supergfxd.path = [ pkgs.pciutils ];
  };
}