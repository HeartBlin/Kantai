{ config, ... }:

{
  nimic.nixos.Reason.module = _: let
    inherit (config.flake.modules) nixos;
  in {
    imports = [
      nixos._Reason-Disko
      nixos._Reason-Constants
      nixos.core
    ];

    networking.hostName = "Reason";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
