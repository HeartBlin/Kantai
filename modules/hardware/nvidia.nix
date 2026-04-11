{
  flake.modules.nixos.nvidia = { config, lib, pkgs, ... }: let
    inherit (config.nimic.nvidia) perDinam prime amdgpuBusId nvidiaBusId;
  in {
    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config = {
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    boot = {
      blacklistedKernelModules = [ "nouveau" ];
      initrd.kernelModules = [
        "nvidia"
        "nvidiafb"
        "nvidia-drm"
        "nvidia-uvm"
        "nvidia-modeset"
      ];
    };

    hardware = {
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        modesetting.enable = true;
        open = true;
        nvidiaSettings = false;
        nvidiaPersistenced = perDinam;
        dynamicBoost.enable = perDinam;
        powerManagement.enable = true;
        prime = lib.mkIf prime {
          inherit nvidiaBusId amdgpuBusId;
          offload = {
            enable = prime;
            enableOffloadCmd = prime;
            offloadCmdMainProgram = "prime-run";
          };
        };
      };

      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
      };
    };

    environment.systemPackages = with pkgs; [
      btop
      nvtopPackages.nvidia
      vulkan-tools
      vulkan-loader
      vulkan-extension-layer
      libva
      libva-utils
    ];
  };
}
