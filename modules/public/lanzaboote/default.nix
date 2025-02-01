{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce mkIf;
  inherit (config.Kantai) lanzaboote;
in {
  config = mkIf lanzaboote.enable {
    environment.systemPackages = with pkgs; [ sbctl ];
    boot.loader.systemd-boot.enable = mkForce false;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
