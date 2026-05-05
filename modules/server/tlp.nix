_:

{
  services = {
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_BOOST_ON_AC = 1;
        RUNTIME_PM_ON_AC = "auto";
        PCIE_ASPM_ON_AC = "powersupersave";
        SOUND_POWER_SAVE_ON_AC = 1;
        SOUND_POWER_SAVE_CONTROLLER = "Y";
        WOL_DISABLE = "Y";
      };
    };
  };
}
