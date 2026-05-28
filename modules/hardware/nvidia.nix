{ config, pkgs, ... }:

{
  nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.systemPackages = [ pkgs.btop ];
  hardware = {
    nvidia = {
      branch = "bleeding_edge";
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "610.43.02";
        sha256_64bit = "sha256:0qvllxnb20arjhw3bxdz0hw521di9ib75hldzx97gpscpdaa0d1h";
        openSha256 = "sha256-hP5NVZZ4vGsACHLmUDKq4uckpd/kn1GxCSYnnJfAuBs=";
        sha256_aarch64 = "";
        settingsSha256 = "";
        persistencedSha256 = "";
      };

      open = true;
      gsp.enable = true;
      nvidiaSettings = false;
      powerManagement.enable = true;

      moduleParams.nvidia = {
        NVreg_EnableResizableBar = 1;
        NVreg_UsePageAttributeTable = 1;
        NVreg_EnableGpuFirmware = 0;
      };

      prime = {
        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = "PCI:6@0:0:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  boot = {
    kernelParams = [ "nvidia-drm.modeset=1" "nvidia-drm.fbdev=1" ];
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };
}
