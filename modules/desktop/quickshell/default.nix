{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.quickshell ];
  hjem.users.${config.kantai.user}.files.".config/quickshell".source = ./.;
  services.upower.enable = true;
}
