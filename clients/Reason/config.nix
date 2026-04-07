{ config, ... }:

{
  nimic.nixos.Reason.module = {
    imports = with config.flake.modules.nixos; [
      # Mandatory
      _Reason-Disko
      _Reason-Constants
      core

      ssh
    ];

    networking.hostName = "Reason";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
