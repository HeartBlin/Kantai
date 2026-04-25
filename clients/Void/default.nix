let
  apps = ../../modules/apps;
  core = ../../modules/core;
  desktop = ../../modules/desktop;
  hardware = ../../modules/hardware;
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
    "${apps}/chromium.nix"
    "${apps}/discord.nix"
    "${apps}/fish.nix"
    "${apps}/foot.nix"
    "${apps}/gaming.nix"
    "${apps}/git.nix"
    "${apps}/uni.nix"
    "${apps}/vscode.nix"
    "${apps}/waydroid.nix"
    "${apps}/winboat.nix"

    # Desktop
    "${desktop}/fonts.nix"
    "${desktop}/gdm.nix"
    "${desktop}/hyprland.nix"
    "${desktop}/plymouth.nix"
    "${desktop}/theme.nix"
    "${desktop}/vicinae.nix"

    # Hardware
    "${hardware}/amd.nix"
    "${hardware}/asus.nix"
    "${hardware}/audio.nix"
    "${hardware}/bluetooth.nix"
    "${hardware}/nvidia.nix"

    # Custom options
    { nimic.user = "heartblin"; }
    { nimic.email = "26450233-heart.blin@users.noreply.gitlab.com"; }
    { nimic.name = "HeartBlin"; }

    # System ID
    { networking.hostName = "Void"; }
    { system.stateVersion = "26.05"; }

    # Other
    { services.fstrim.enable = true; }
    ({ pkgs, ... }: { boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3; })
  ]
