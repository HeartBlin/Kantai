{
  flake.modules.nixos.gaming = { lib, pkgs, ... }: {
    programs = {
      gamemode = let
        bin = lib.makeBinPath [ pkgs.coreutils pkgs.libnotify pkgs.hyprland ];
        start =
          (pkgs.writeShellScript "gamemodeStart" ''
            export PATH=$PATH:${bin}
            export XDG_RUNTIME_DIR=/run/user/$(id -u)
            export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t ''${XDG_RUNTIME_DIR}/hypr 2>/dev/null | head -n 1)

            hyprctl --batch "\
              keyword animations:enabled 0;\
              keyword animation borderangle,0; \
              keyword decoration:shadow:enabled 0;\
              keyword decoration:blur:enabled 0;\
              keyword decoration:fullscreen_opacity 1;\
              keyword general:gaps_in 0;\
              keyword general:gaps_out 0;\
              keyword general:border_size 1;\
              keyword decoration:rounding 0"
          '').outPath;

        end =
          (pkgs.writeShellScript "gamemodeEnd" ''
            export PATH=$PATH:${bin}
            export XDG_RUNTIME_DIR=/run/user/$(id -u)
            export HYPRLAND_INSTANCE_SIGNATURE=$(ls -t ''${XDG_RUNTIME_DIR}/hypr 2>/dev/null | head -n 1)

            hyprctl reload
          '').outPath;
      in {
        enable = true;
        enableRenice = false;
        settings = {
          custom = { inherit start end; };
          general = {
            softrealtime = "auto";
          };
        };
      };

      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        package = pkgs.steam.override {
          extraArgs = "-system-composer";
          extraEnv = {
            PROTON_ENABLE_NGX_UPDATER = "1";
            DXVK_NVAPI_DRS_SETTINGS = "NGX_DLSS_RR_OVERRIDE=on,NGX_DLSS_SR_OVERRIDE=on,NGX_DLSS_FG_OVERRIDE=on,NGX_DLSS_RR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_latest,NGX_DLSS_SR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_latest";
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
          };
        };
      };
    };

    environment = {
      sessionVariables."PROTON_NO_WM_DECORATION" = "1";
      systemPackages = with pkgs; [
        protonplus
        protontricks
        (prismlauncher.override { jdks = [ openjdk21 graalvmPackages.graalvm-ce ]; })
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
  };
}
