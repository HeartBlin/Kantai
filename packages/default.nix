{ pkgs, ... }:

{
  packages = {
    alejandra-custom = pkgs.callPackage ./alejandra-custom { };
    ltspice = pkgs.callPackage ./ltspice { };
    wallpaper-walk = pkgs.callPackage ./wallpaper-walk { };
  };
}
