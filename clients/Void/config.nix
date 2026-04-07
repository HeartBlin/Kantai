{ config, ... }:

{
  nimic.nixos.Void.module = {
    imports = with config.flake.modules.nixos; [
      # Mandatory
      _Void-Disko
      _Void-Constants
      core

      audio
      amd
      asus
      git
      plymouth
    ];

    networking.hostName = "Void";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
