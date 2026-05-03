{ config, lib, pkgs, ... }:

{
  programs = {
    gpu-screen-recorder.enable = true;
    gamemode = let
      start = (pkgs.writeShellScript "gs" "${pkgs.asusctl}/bin/asusctl profile set Performance").outPath;
      end = (pkgs.writeShellScript "ge" "${pkgs.asusctl}/bin/asusctl profile set Quiet").outPath;
    in {
      enable = true;
      enableRenice = false;
      settings = {
        custom = { inherit start end; };
        general.softrealtime = "auto";
      };
    };

    steam = {
      enable = true;
      package = pkgs.steam.override { extraArgs = "-system-composer"; };
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };

  environment = {
    sessionVariables =
      {
        "PROTON_NO_WM_DECORATION" = 1;
        "PROTON_USE_WOW64" = 1;
      }
      // lib.optionalAttrs config.hardware.nvidia.enabled {
        "__GL_SHADER_DISK_CACHE" = 1;
        "__GL_SHADER_DISK_CACHE_SIZE" = 17179869184; # 16GB
        "__GL_SHADER_DISK_CACHE_PATH" = "$XDG_CACHE_HOME/nsc";
        "__GL_SYNC_TO_VBLANK" = 0;
        "__GL_MaxFramesAllowed" = 1;
      };

    systemPackages = with pkgs; [
      protonplus
      gpu-screen-recorder-gtk
    ];
  };

  # SteamOS kernel tweaks
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "kernel.split_lock_mitigate" = 0;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "net.ipv4.tcp_fin_timeout" = 5;
  };

  # Ananicy-cpp
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # NTSync
  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''KERNEL=="ntsync", MODE="0666", TAG+="uaccess"'';
}
