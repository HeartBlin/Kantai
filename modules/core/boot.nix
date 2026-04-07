{ inputs, ... }:

{
  flake.modules.nixos.core = { config, lib, ... }: let
    iStrix = config.networking.hostName == "Strix";
  in {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot = {
      kernelParams =
        [
          "splash"
          "quiet"
          "loglevel=3"
          "systemd.show_status=auto"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
        ]
        ++ lib.optional iStrix "i8042.nokbd";

      initrd.systemd.enable = true;
      bootspec.enable = true;
      loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = false;
      };

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
        };
      };
    };
  };
}
