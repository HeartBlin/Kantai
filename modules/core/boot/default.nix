{ lib, ... }:

let inherit (lib) mkForce;
in {
  boot = {
    bootspec.enable = mkForce true;
    initrd.systemd.enable = mkForce true;
    consoleLogLevel = mkForce 3;
    kernelParams = [
      "quiet"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    tmp = {
      cleanOnBoot = mkForce true;
      useTmpfs = mkForce true;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 0;
    };
  };
}
