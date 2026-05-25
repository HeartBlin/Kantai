{ config, lib, pkgs, ... }:

{
  security.pam.services = {
    login.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
  };

  services = {
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };

    greetd = {
      enable = true;
      restart = true;
      useTextGreeter = true;
      settings.default_session = {
        command = lib.concatStringsSep " " [
          "${lib.getExe pkgs.tuigreet}"
          "--time"
          "--remember"
          "--asterisks"
          (lib.optionalString config.programs.hyprland.enable "--cmd hyprland")
        ];
      };
    };
  };
}
