{ config, pkgs, self', ... }:

{
  programs.nix-ld.enable = true;
  users.users.${config.nimic.user}.extraGroups = [ "dialout" ];
  environment.systemPackages = with pkgs; [
    dosbox
    self'.packages.ltspice
  ];
}
