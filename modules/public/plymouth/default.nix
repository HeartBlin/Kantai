{ config, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (config.Kantai) plymouth;
in {
  config = mkIf plymouth.enable {
    boot.plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };
}
