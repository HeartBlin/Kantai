{
  flake.modules.nixos.intel = {
    hardware = {
      cpu.intel.updateMicrocode = true;
      enableRedistributableFirmware = true;
    };
  };
}
