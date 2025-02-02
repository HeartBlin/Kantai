{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkIf;
  inherit (config.Kantai) nvidia;

  # bleedingEdge = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #   version = "570.86.16";
  #   sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
  #   sha256_aarch64 = "sha256-aDVc3sNTG4O3y+vKW87mw+i9AqXCY29GVqEIUlsvYfE=";
  #   openSha256 = "sha256-/tM3n9huz1MTE6KKtTCBglBMBGGL/GOHi5ZSUag4zXA=";
  #   settingsSha256 = "sha256-H7uEe34LdmUFcMcS6bz7sbpYhg9zPCb/5AmZZFTx1QA=";
  #   persistencedSha256 = "sha256-3mp9X/oV8o2TH9720NnoXROxQ4g98nNee+DucXpQy3w=";
  # };
in {
  config = mkIf nvidia.enable {
    nixpkgs.config = {
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.kernelParams = [
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.modeset=1"
      "nvidia_drm.fbdev=1"
    ];

    environment.systemPackages = [
      pkgs.btop

      pkgs.vulkan-tools
      pkgs.vulkan-loader
      pkgs.vulkan-extension-layer

      pkgs.libva
      pkgs.libva-utils
    ];

    hardware.nvidia = {
      package =  config.boot.kernelPackages.nvidiaPackages.beta;

      dynamicBoost.enable = true;
      modesetting.enable = true;

      powerManagement = {
        enable = mkDefault true;
        finegrained = mkDefault true;
      };

      nvidiaSettings = false;
      open = true;
      nvidiaPersistenced = true;
    };

    hardware.graphics = {
      enable32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };
  };
}