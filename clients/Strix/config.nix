{ config, ... }:

{
  nimic.nixos.Strix.module = _: let
    inherit (config.flake.modules) nixos;
  in {
    imports = [
      # Mandatory
      nixos._Strix-Disko
      nixos._Strix-Constants
      nixos.core

      nixos.git
    ];

    networking.hostName = "Strix";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
