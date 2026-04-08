{ pkgs, ... }:

pkgs.writers.writeHaskellBin "wallpaper-walk" {
  libraries = with pkgs.haskellPackages; [ directory filepath process ];
} (builtins.readFile ./main.hs)
