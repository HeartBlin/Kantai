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
      extraCompatPackages = [
        pkgs.proton-ge-bin
        pkgs.dwproton-bin
      ];

      package = pkgs.steam.override {
        extraArgs = "-system-composer";
        extraEnv = {
          PROTON_NO_WM_DECORATION = 1;
          PROTON_USE_WOW64 = 1;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    protonplus
    gpu-screen-recorder-gtk

    (lib.hiPrio (pkgs.writeShellScriptBin "steam" ''
      exec ${pkgs.util-linux}/bin/setpriv --ambient-caps -all -- ${config.programs.steam.package}/bin/steam "$@"
    ''))
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
