{ config, inputs', lib, pkgs, self', ... }:

{
  hjem.users.${config.nimic.user}.files = {
    ".config/hypr/hyprland.lua".source = ./hyprland.lua;
    ".config/hypr/_autostart.lua".source = ./_autostart.lua;
    ".config/hypr/_binds.lua".source = ./_binds.lua;
    ".config/hypr/_envs.lua".source = ./_envs.lua;
    ".config/hypr/_monitors.lua".source = ./_monitors.lua;
    ".config/hypr/_rules.lua".source = ./_rules.lua;
    ".config/hypr/_settings.lua".source = ./_settings.lua;
  };

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
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
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
    sessionVariables = let
      isNvidia = x: lib.optionalString config.hardware.nvidia.enabled x;
      isFoot = x: lib.optionalString config.programs.foot.enable x;
    in {
      LIBVA_DRIVER_NAME = isNvidia "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = isNvidia "nvidia";
      NVD_BACKEND = isNvidia "direct";
      TERMINAL = isFoot "foot";
    };

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
