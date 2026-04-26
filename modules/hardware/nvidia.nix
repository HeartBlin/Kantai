{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.systemPackages = [ pkgs.btop ];
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = false;
      nvidiaSettings = false;
      dynamicBoost.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };

      prime = {
        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = "PCI:6@0:0:0";
        offload = {
          enable = true;
          enableOffloadCmd = true;
          offloadCmdMainProgram = "prime-run";
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  boot = {
    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];

    kernelParams = [
      "nvidia.NVreg_EnableResizableBAR=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
    ];
  };
}
