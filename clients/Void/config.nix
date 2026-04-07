{ config, ... }:

{
  nimic.nixos.Void.module = _: let
    inherit (config.flake.modules) nixos;
  in {
    imports = [
      # Mandatory
      nixos._Void-Disko
      nixos._Void-Constants
      nixos.core

      nixos.amd
      nixos.git
      nixos.plymouth
    ];

    networking.hostName = "Void";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
