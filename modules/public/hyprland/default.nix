{ config, inputs', lib, pkgs, self', ... }:

let
  inherit (lib) getExe mkIf;
  inherit (config.Kantai) chrome foot hyprland nvidia vscode;

  hyprlandConfig = ''
    ### Monitors ###
    monitor=,preferred,auto,1
    monitor = eDP-1, 1920x1080@144, 0x0, 1

    ### Programs ###
    $terminal = ${if foot.enable then "foot" else getExe pkgs.kitty}
    $fileManager = ${getExe pkgs.nautilus}
    $menu = ${getExe pkgs.rofi-wayland} -show drun
    $browser = ${if chrome.enable then "chromium" else getExe pkgs.firefox}
    $editor = ${if vscode.enable then "code" else getExe pkgs.neovim}

    ### Autostart ###
    exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    exec-once = ${getExe self'.packages.ags}

    ### Environment variables ###
    env = XCURSOR_SIZE,24
    env = HYPRCURSOR_SIZE,24
    ${if nvidia.enable then ''
      env = LIVBA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = NVD_BACKEND,direct'' else
      ""}

    ### Look and Feel ###
    general {
      gaps_in = 5
      gaps_out = 10
      border_size = 1
      col.active_border = rgba(33ccffee)
      col.inactive_border = rgba(595959aa)
      resize_on_border = true
      allow_tearing = false
      layout = dwindle
    }

    decoration {
      rounding = 15
      active_opacity = 1.0
      inactive_opacity = 1.0

      shadow {
        enabled = true
        range = 10
        render_power = 2
        color = rgba(0, 0, 0, 0.25)
      }

      blur {
        enabled = true
        size = 5
        passes = 3
        new_optimizations = true
        contrast = 1
        brightness = 1
        vibrancy = 0.1696
      }
    }

    animations {
      enabled = true
      bezier = tran, .5, .25, 0, 1
      animation = windows, 1, 2.5, tran, popin 80%
      animation = border, 1, 2.5, tran
      animation = fade, 1, 2.5, tran
      animation = workspaces, 1, 2.5, tran, slidefade 20%
    }

    dwindle {
      pseudotile = true
      preserve_split = true
    }

    master {
      new_status = master
    }

    misc {
      always_follow_on_dnd = true
      animate_manual_resizes = false
      background_color = rgb(000000)
      disable_hyprland_logo = true
      disable_autoreload = false
      disable_splash_rendering = true
      force_default_wallpaper = 2
      key_press_enables_dpms = true
      mouse_move_enables_dpms = true
    }

    ### INPUT ###
    input {
      kb_layout = ro
      follow_mouse = 1
      sensitivity = 0
      touchpad {
        natural_scroll = false
      }
    }

    gestures {
      workspace_swipe = true
    }

    ### KEYBINDS ###
    $mainMod = SUPER

    # Actions
    bind = $mainMod, Q, killactive
    bind = $mainMod Shift, Q, exit
    bind = $mainMod, F, fullscreen
    bind = $mainMod, T, togglefloating

    # Programs
    bind = $mainMod, Return, exec, $terminal
    bind = $mainMod, E, exec, $fileManager
    bind = $mainMod, Space, exec, $menu
    bind = $mainMod, W, exec, $browser
    bind = $mainMod, C, exec, $editor

    # Switch workspaces
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # move active window to workstation
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Move/resize with mouse
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Volume/Brightness

    # PlayerCTL
    bindl = , XF86AudioNext, exec, playerctl next
    bindl = , XF86AudioPause, exec, playerctl pause
    bindl = , XF86AudioPlay, exec, playerctl play
    bindl = , XF86AudioPrev, exec, playerctl previous

    ### Windows and Workspaces ###
    windowrulev2 = suppressevent maximize, class:.*
    windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
  '';
in {
  config = mkIf hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs'.hyprland.packages.hyprland;
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    };

    environment = {
      systemPackages = [ self'.packages.ags ];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    homix.".config/hypr/hyprland.conf".text = hyprlandConfig;
  };
}
