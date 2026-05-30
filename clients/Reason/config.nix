{ pkgs, self, ... }:

let
  apps = "${self}/modules/apps";
  core = "${self}/modules/core";
  hardware = "${self}/modules/hardware";
  server = "${self}/modules/server";
in {
  imports = [
    # Core
    "${core}/boot.nix"
    "${core}/i18n.nix"
    "${core}/networking.nix"
    "${core}/nix.nix"
    "${core}/security.nix"
    "${core}/sudo.nix"
    "${core}/user.nix"
    "${core}/vars.nix"
    "${core}/zram.nix"

    # Apps
    "${apps}/fish.nix"

    # Hardware
    "${hardware}/intel.nix"

    # Server
    "${server}/backup.nix"
    "${server}/caddy.nix"
    "${server}/immich.nix"
    "${server}/jellyfin.nix"
    "${server}/samba.nix"
    "${server}/scrutiny.nix"
    "${server}/secrets.nix"
    "${server}/ssh.nix"
    "${server}/vaultwarden.nix"
  ];

  # Custom options
  kantai = {
    user = "server";
    name = "Reason";
  };

  # Misc
  services.fstrim.enable = true;
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "libata.noacpi=1"
      "nowatchdog"
      "reboot=pci"
      "consoleblank=60"
    ];
  };

  users.users."server".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEISJfRd1QeAC48Vkd4gNLZj9bPnmXDal2F9rc+3V9oI heartblin@Void"
  ];

  # System ID
  networking.hostName = "Reason";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
