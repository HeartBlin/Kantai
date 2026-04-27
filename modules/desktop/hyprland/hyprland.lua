-- Monitors --
hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@144",
  position = "0x0",
  scale = "1"
})

hl.monitor({
  output = "",
  mode = "highres",
  position = "auto",
  scale = "1"
})

-- At startup --
hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
  hl.exec_cmd("vicinae server")
  hl.exec_cmd("awww-daemon")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "waylandx11*")
hl.env("QT_QPA_PLATFORM", "waylandxcb")
hl.env("QT_QPA_PLATFORMTHEME", "gnome")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("TERMINAL", "foot")

hl.config({
  general = {
    allow_tearing = true,
    border_size = 2,
    gaps_in = 5,
    gaps_out = 10,
    resize_on_border = true,

    col = {
      inactive_border = "0xff444444",
      active_border = {
        angle = 45,
        colors = {
          "0xffef7e7e", "0xffe57474", "0xfff4d67a", "0xffe5c76b",
          "0xff96d988", "0xff8ccf7e", "0xff67cbe7",
          "0xff6cbfbf", "0xff71baf2", "0xffc47fd5"
        }
      }
    }
  },

  decoration = {
    dim_inactive = true,
    dim_strength = 0.05,
    rounding = 18,
    rounding_power = 2.4,

    blur = {
      enabled = true,
      brightness = 1.0,
      contrast = 1.0,
      new_optimizations = true,
      noise = 0.05,
      passes = 3,
      popups = true,
      popups_ignorealpha = 0.2,
      size = 10,
      vibrancy = 0.5,
      vibrancy_darkness = 0.5,
      xray = true
    },

    shadow = {
      enabled = true,
      color = "0x00000055",
      offset = "0 4",
      range = 50,
      render_power = 2,
      scale = 1.0
    },
  },

  input = {
    follow_mouse = 1,
    kb_layout = "ro",
    sensitivity = 0,

    touchpad = {
      clickfinger_behavior = true,
      disable_while_typing = true,
      natural_scroll = false,
      tap_to_click = true
    }
  },

  ecosystem = {
    no_donation_nag = true,
    no_update_news = true
  },

  cursor = { no_hardware_cursors = 0 },
  render = { direct_scanout = 1 },
  xwayland = { force_zero_scaling = true },
  dwindle = { preserve_split = true },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    enable_swallow = false,
    middle_click_paste = false
  }
})

-- Apps
hl.bind("SUPER + Return", hl.dsp.exec_cmd("foot"))
hl.bind("SUPER + Space", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("chromium"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -o ~/Pictures/Screenshots -m region"))

-- Window Management
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + ALT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.exit())

-- Utility
hl.bind("ALT + E", hl.dsp.exec_cmd("wallpaper-walk inc"))
hl.bind("ALT + Q", hl.dsp.exec_cmd("wallpaper-walk dec"))

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true }
)

hl.bind("XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl set +5%"),
  { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl set 5%-"),
  { locked = true, repeating = true }
)

hl.bind("XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true }
)

-- Mouse Binds
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- Layer Rule
hl.layer_rule({ match = { namespace = "vicinae" }, blur = true })

-- Window Rules
hl.window_rule({ name = "no-shadow-tiled", match = { float = false }, no_shadow = true })
hl.window_rule({ name = "immediate-exe", match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ name = "immediate-steam", match = { class = "^(steam_app).*" }, immediate = true })
hl.window_rule({ name = "waydroid-fs", match = { class = "Waydroid" }, fullscreen = true })
