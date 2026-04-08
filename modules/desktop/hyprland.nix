{ inputs, moduleWithSystem, ... }:

{
  flake.modules.nixos.hyprland = moduleWithSystem ({ inputs', self', ... }: { pkgs, ... }: {
    imports = [ inputs.hyprland.nixosModules.default ];
    programs = {
      dconf.enable = true;
      seahorse.enable = true;
      hyprland = {
        enable = true;
        package = inputs'.hyprland.packages.hyprland;
        portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;

        settings = {
          monitor = [
            "eDP-1, 1920x1080@144, 0x0, 1"
            ", preferred, auto, 1"
          ];

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "GDK_BACKEND,wayland,x11,*"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_QPA_PLATFORMTHEME,gnome"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "SDL_VIDEODRIVER,wayland"
            "ELECTRON_OZONE_PLATFORM_HINT,wayland"
            "OZONE_PLATFORM,wayland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "TERMINAL, foot"
          ];

          exec-once = [
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
            "hyprctl setcursor Bibata-Modern-Ice 24"
            "hyprpaper"
            "vicinae server"
            "GalaxyBudsClient /StartMinimized"
            "awww-daemon"
          ];

          general = {
            allow_tearing = true;
            border_size = 2;
            "col.active_border" = "0xffef7e7e 0xffe57474 0xfff4d67a 0xffe5c76b 0xff96d988 0xff8ccf7e 0xff67cbe7 0xff6cbfbf 0xff71baf2 0xffc47fd5 45deg";
            "col.inactive_border" = "0xff444444";
            gaps_in = 5;
            gaps_out = 10;
            resize_on_border = true;
          };

          decoration = {
            rounding = 18;
            rounding_power = 2.4;

            blur = {
              brightness = 1.000000;
              contrast = 0.9;
              enabled = true;
              noise = 0.05;
              passes = 3;
              popups = true;
              popups_ignorealpha = 0.200000;
              size = 10;
              vibrancy = 0.500000;
              vibrancy_darkness = 0.500000;
              xray = true;
              new_optimizations = true;
            };

            shadow = {
              color = "0x00000055";
              enabled = true;
              ignore_window = true;
              offset = "0 4";
              range = 50;
              render_power = 2;
              scale = 1.000000;
            };

            dim_inactive = true;
            dim_strength = 0.05;
          };

          input = {
            follow_mouse = true;
            kb_layout = "ro";
            sensitivity = 0;
            touchpad = {
              clickfinger_behavior = true;
              disable_while_typing = true;
              natural_scroll = false;
              tap-to-click = true;
            };
          };

          windowrule = [
            "match:float 0, no_shadow on"
            "match:title .*\\.exe, immediate on"
            "match:class ^(steam_app).*, immediate on"
            "match:class .*missioncenter.*, float on"
            "match:class .*missioncenter.*, size 850 935"
            "match:class Waydroid, fullscreen on"
          ];

          layerrule = [
            "blur on, match:namespace vicinae"
            "ignore_alpha 0, match:namespace brightness-osd"
            "dim_around off, match:namespace brightness-osd"
            "above_lock 1, match:namespace brightness-osd"
            "animation slide left, match:namespace brightness-osd"
            "ignore_alpha 0, match:namespace volume-osd"
            "dim_around off, match:namespace volume-osd"
            "above_lock 1, match:namespace volume-osd"
            "animation slide right, match:namespace volume-osd"
          ];

          render.direct_scanout = "1";
          xwayland.force_zero_scaling = true;
          misc.disable_hyprland_logo = true;
          ecosystem = {
            no_donation_nag = true;
            no_update_news = true;
          };

          bind = [
            "Super, Return, exec, foot"
            "Super, Space, exec, vicinae toggle"
            "Super, E, exec, nautilus"
            "Super, W, exec, chromium"
            ", Print, exec, hyprshot -o ~/Pictures/Screenshots -m region"
            "Control, Print, exec, hyprshot -o ~/Pictures/Screenshots -m window"
            "Alt, Print, exec, hyprshot -o ~/Pictures/Screenshots -m output"
            "Super Alt, F, fullscreen"
            "Super, F, togglefloating"
            "Super, Q, killactive"
            "Super Shift, Q, exit"
            "Super Shift Control Tab, Q, exec, systemctl poweroff"
            "Control Shift, Escape, exec, missioncenter"
            "LAlt, E, exec, wallpaper-walk inc"
            "LAlt, Q, exec, wallpaper-walk dec"

            "Super, 1, workspace, 1"
            "Super, 2, workspace, 2"
            "Super, 3, workspace, 3"
            "Super, 4, workspace, 4"
            "Super, 5, workspace, 5"
            "Super, 6, workspace, 6"
            "Super, 7, workspace, 7"
            "Super, 8, workspace, 8"
            "Super, 9, workspace, 9"
            "Super, 0, workspace, 10"

            "Super Shift, 1, movetoworkspace, 1"
            "Super Shift, 2, movetoworkspace, 2"
            "Super Shift, 3, movetoworkspace, 3"
            "Super Shift, 4, movetoworkspace, 4"
            "Super Shift, 5, movetoworkspace, 5"
            "Super Shift, 6, movetoworkspace, 6"
            "Super Shift, 7, movetoworkspace, 7"
            "Super Shift, 8, movetoworkspace, 8"
            "Super Shift, 9, movetoworkspace, 9"
            "Super Shift, 0, movetoworkspace, 10"
          ];

          bindm = [
            "Super, mouse:272, movewindow" # left click
            "Super, mouse:273, resizewindow" # right click
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
            ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ];

          bindl = [ ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
        };
      };
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
        hyprlock.enableGnomeKeyring = true;
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
        loupe
        file-roller
        gnome-disk-utility
        hyprshot
        libnotify
        mission-center
        brightnessctl
        glib
        gsettings-desktop-schemas
        awww
        self'.packages.wallpaper-walk
      ];
    };
  });
}
