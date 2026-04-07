{
  flake.modules.nixos.plymouth = {
    boot = {
      plymouth = {
        enable = true;
        theme = "bgrt";
      };

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
      ];
    };
  };
}
