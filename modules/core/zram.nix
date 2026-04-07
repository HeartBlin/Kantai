{
  flake.modules.nixos.core = {
    zramSwap = {
      enable = true;
      priority = 100;
      memoryPercent = 50;
    };
  };
}
