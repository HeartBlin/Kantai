{ lib, ... }:

let
  inherit (lib) mkForce;
in {
  boot = {
    bootspec.enable = mkForce true;
    initrd.systemd.enable = mkForce true;
    consoleLogLevel = mkForce 3;
    kernelParams = [ "quiet" "systemd.show_status=auto" "rd.udev.log_level=3" ];

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
