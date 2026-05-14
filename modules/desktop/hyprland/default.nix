{ config, pkgs, ... }:

{
  hjem.users.${config.kantai.user}.files = {
    ".config/hypr/hyprland.lua".source = ./hyprland.lua;
    ".config/hypr/_autostart.lua".source = ./_autostart.lua;
    ".config/hypr/_binds.lua".source = ./_binds.lua;
    ".config/hypr/_envs.lua".source = ./_envs.lua;
    ".config/hypr/_monitors.lua".source = ./_monitors.lua;
    ".config/hypr/_rules.lua".source = ./_rules.lua;
    ".config/hypr/_settings.lua".source = ./_settings.lua;
    ".config/hypr/_wallpaper.lua".source = ./_wallpaper.lua;
  };

  programs = {
    hyprland.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    ssh.enableAskPassword = true;
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

  environment.systemPackages = with pkgs; [
    libsecret
    nautilus
    file-roller
    hyprshot
    brightnessctl
    glib
    gsettings-desktop-schemas
    awww
  ];
}
