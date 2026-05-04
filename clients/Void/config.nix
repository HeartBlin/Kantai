{ pkgs, self, ... }:

let
  apps = "${self}/modules/apps";
  core = "${self}/modules/core";
  desktop = "${self}/modules/desktop";
  hardware = "${self}/modules/hardware";
in {
  imports = [
    ./disko.nix

    # Core
    "${core}/boot.nix"
    "${core}/i18n.nix"
    "${core}/networking.nix"
    "${core}/nix.nix"
    "${core}/sudo.nix"
    "${core}/user.nix"
    "${core}/vars.nix"
    "${core}/zram.nix"

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
    "${desktop}/hyprland"
    "${desktop}/plymouth.nix"
    "${desktop}/theme.nix"
    "${desktop}/vicinae.nix"

    # Hardware
    "${hardware}/amd.nix"
    "${hardware}/asus.nix"
    "${hardware}/audio.nix"
    "${hardware}/bluetooth.nix"
    "${hardware}/nvidia.nix"
  ];

  # Custom options
  nimic = {
    user = "heartblin";
    email = "26450233-heart.blin@users.noreply.gitlab.com";
    name = "HeartBlin";
  };

  # Other
  services.fstrim.enable = true;
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    resumeDevice = "/dev/mapper/crypted";
    kernelParams = [ "resume_offset=533760" ];
  };

  # System ID
  networking.hostName = "Void";
  system.stateVersion = "26.05";
}
