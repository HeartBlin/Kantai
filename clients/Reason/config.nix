{ config, ... }:

{
  nimic.nixos.Reason.module = {
    imports = with config.flake.modules.nixos; [
      # Mandatory
      _Reason-Disko
      _Reason-Constants
      core

      fish
      intel
      nvidia
      ssh
    ];

    services.fstrim.enable = true;
    users.users."server".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEISJfRd1QeAC48Vkd4gNLZj9bPnmXDal2F9rc+3V9oI heartblin@Styx"
    ];

    networking.hostName = "Reason";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.05";
  };
}
