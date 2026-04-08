{ config, ... }:

{
  nimic.nixos.Void.module = { pkgs, ... }: {
    imports = with config.flake.modules.nixos; [
      # Mandatory
      _Void-Disko
      _Void-Constants
      core

      audio
      amd
      asus
      bluetooth
      chromium
      fish
      fonts
      foot
      gaming
      gdm
      git
      nvidia
      plymouth
      uni
      vicinae
      vscode
      waydroid
      winboat
    ];

    services.fstrim.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    networking.hostName = "Void";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
