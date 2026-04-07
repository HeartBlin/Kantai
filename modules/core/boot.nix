{ inputs, ... }:

{
  flake.modules.nixos.core = {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot = {
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
