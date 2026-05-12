{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.systemPackages = [ pkgs.btop ];
  hardware = {
    nvidia = rec {
      branch = "bleeding_edge";
      open = true;
      gsp.enable = open;
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
          offloadCmdMainProgram = "prime-run";
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
