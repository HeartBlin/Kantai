{ ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    timeout = 0;
  };

  boot.loader.efi.canTouchEfiVariables = true;
}