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
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      package = pkgs.steam.override {
        extraArgs = "-system-composer";
        extraEnv =
          {
            PROTON_NO_WM_DECORATION = 1;
            PROTON_USE_WOW64 = 1;
          }
          // lib.optionalAttrs config.hardware.nvidia.enabled {
            PROTON_ENABLE_NVAPI = 1;
            __NV_PRIME_RENDER_OFFLOAD = 1;
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";

            __GL_SYNC_TO_VBLANK = 0;
            __GL_MaxFrameAllowed = 1;
            __GL_SHADER_DISK_CACHE = 1;
            __GL_SHADER_DISK_CACHE_SIZE = 17179869184; # 16GB
          };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    protonplus
    gpu-screen-recorder-gtk
  ];

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
}
