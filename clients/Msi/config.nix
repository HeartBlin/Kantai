{ config, ... }:

{
  nimic.nixos.Msi.module = _: let
    inherit (config.flake.modules) nixos;
  in {
    imports = [
      nixos._Msi-Disko
      nixos._Msi-Constants
      nixos.core
    ];

    networking.hostName = "Msi";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
