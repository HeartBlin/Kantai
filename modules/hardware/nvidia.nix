{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      open = true;
      nvidiaSettings = false;
      nvidiaPersistenced = true;
      dynamicBoost.enable = true;
      powerManagement.enable = true;
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
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };
  };

  environment.systemPackages = with pkgs; [ btop ];
}
