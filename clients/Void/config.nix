{ pkgs, self, ... }:

let
  apps = "${self}/modules/apps";
  core = "${self}/modules/core";
  desktop = "${self}/modules/desktop";
  hardware = "${self}/modules/hardware";
in {
  imports = [
    # Core
    "${core}/boot.nix"
    "${core}/i18n.nix"
    "${core}/networking.nix"
    "${core}/nix.nix"
    # "${core}/security.nix"
    "${core}/sudo.nix"
    "${core}/user.nix"
    "${core}/vars.nix"
    "${core}/zram.nix"

    # Apps
    "${apps}/chromium.nix"
    "${apps}/fish.nix"
    "${apps}/foot.nix"
    "${apps}/gaming.nix"
    "${apps}/git.nix"
    "${apps}/ssh.nix"
    "${apps}/uni.nix"
    "${apps}/vscodium.nix"
    "${apps}/waydroid.nix"
    "${apps}/winboat.nix"

    # Desktop
    "${desktop}/fonts.nix"
    "${desktop}/greetd.nix"
    "${desktop}/hyprland"
    "${desktop}/quickshell"
    "${desktop}/rofi.nix"
    "${desktop}/theme.nix"

    # Hardware
    "${hardware}/amd.nix"
    "${hardware}/asus.nix"
    "${hardware}/audio.nix"
    "${hardware}/bluetooth.nix"
    "${hardware}/nvidia.nix"
  ];

  # Custom options
  kantai = rec {
    user = "heartblin";
    email = "161874560+HeartBlin@users.noreply.github.com";
    name = "HeartBlin";
    flake = "/home/${user}/Projects/Kantai";
  };

  # Other
  services.fstrim.enable = true;
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    resumeDevice = "/dev/mapper/crypted";
    kernelParams = [ "resume_offset=533760" "nowatchdog" ];
    extraModprobeConfig = "blacklist sp5100_tco"; # shush
  };

  # Temp
  environment.systemPackages = with pkgs; [
    ffmpeg
    (yt-dlp.overrideAttrs (_: {
      version = "master";
      doCheck = false;
      src = fetchFromGitHub {
        owner = "yt-dlp";
        repo = "yt-dlp";
        rev = "master";
        hash = "sha256-FVoPgBrZvpXAJnwUyBIVLQyeWFipD+3kWNJvhkh8eak=";
      };
    }))
  ];

  # System ID
  networking.hostName = "Void";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
