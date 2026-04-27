{ pkgs, self, ... }:

let
  apps = "${self}/modules/apps";
  core = "${self}/modules/core";
  hardware = "${self}/modules/hardware";
  server = "${self}/modules/server";
in {
  imports = [
    ./disko.nix

    # Core
    "${core}/vars.nix"
    "${core}/user.nix"
    "${core}/nix.nix"
    "${core}/boot.nix"
    "${core}/networking.nix"
    "${core}/zram.nix"
    "${core}/i18n.nix"

    # Apps
    "${apps}/fish.nix"

    # Hardware
    "${hardware}/intel.nix"

    # Server
    "${server}/backup.nix"
    "${server}/glance.nix"
    "${server}/jellyfin.nix"
    "${server}/nextcloud.nix"
    "${server}/nginx.nix"
    "${server}/scrutiny.nix"
    "${server}/ssh.nix"
    "${server}/uptime.nix"
    "${server}/vaultwarden.nix"
  ];

  # Custom options
  nimic.user = "server";

  # Misc
  services.fstrim.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  users.users."server".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEISJfRd1QeAC48Vkd4gNLZj9bPnmXDal2F9rc+3V9oI heartblin@Void"
  ];

  # System ID
  networking.hostName = "Reason";
  system.stateVersion = "26.05";
}
