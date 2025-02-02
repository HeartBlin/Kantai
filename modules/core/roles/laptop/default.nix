{ config, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (config.Kantai) nvidia;
in {
  config = {
    # Force prime if Nvidia is enabled
    hardware.nvidia.prime = mkIf nvidia.enable {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = nvidia.busIDs.amd;
      nvidiaBusId = nvidia.busIDs.nvidia;
    };
  };
}
