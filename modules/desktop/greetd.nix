{ config, pkgs, lib, ... }:

let
  niceLaunch = pkgs.writeShellScript "niceLaunch" ''
    echo -e "\033[1;35mHyprland is starting\033[0m"
    start-hyprland &> /dev/null
  '';
in {
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
          (lib.optionalString config.programs.hyprland.enable "--cmd ${niceLaunch}")
        ];
      };
    };
  };
}
