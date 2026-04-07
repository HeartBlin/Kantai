{ config, ... }:

{
  nimic.nixos.Strix.module = { ... }: let
    inherit (config.flake.modules) nixos;
  in {
    imports = [
      nixos._Strix-Disko
      nixos._Strix-Constants
      nixos.core
    ];

    networking.hostName = "Strix";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
