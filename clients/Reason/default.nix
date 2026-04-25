let
  apps = ../../modules/apps;
  core = ../../modules/core;
  hardware = ../../modules/hardware;
  server = ../../modules/server;
in
  import ../../. [
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

    # Custom options
    { nimic.user = "server"; }

    # System ID
    { networking.hostName = "Reason"; }
    { system.stateVersion = "26.05"; }

    # Other
    { services.fstrim.enable = true; }
    ({ pkgs, ... }: { boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-server-lto; })
    {
      users.users."server".openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEISJfRd1QeAC48Vkd4gNLZj9bPnmXDal2F9rc+3V9oI heartblin@Void"
      ];
    }

    # NVIDIA Tweaks
    { hardware.nvidia.prime.offload.enable = false; }
    { hardware.nvidia.prime.offload.enableOffloadCmd = false; }
    { hardware.nvidia.nvidiaPersistenced = false; }
    { hardware.nvidia.dynamicBoost.enable = false; }
  ]
