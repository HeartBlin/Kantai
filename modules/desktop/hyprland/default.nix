{ config, inputs', pkgs, self', ... }:

{
  hjem.users.${config.nimic.user}.files.".config/hypr/hyprland.lua".source = ./hyprland.lua;

  programs = {
    hyprland = {
      enable = true;
      package = inputs'.hyprland.packages.hyprland;
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    };

    dconf.enable = true;
    seahorse.enable = true;
  };

  services = {
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };

    gvfs.enable = true;
    upower.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services = {
      gdm.enableGnomeKeyring = true;
      gdm-password.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      libsecret
      nautilus
      file-roller
      hyprshot
      brightnessctl
      glib
      gsettings-desktop-schemas
      awww
      self'.packages.wallpaper-walk
    ];
  };
}
