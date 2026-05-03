hl.config({
  general = {
    allow_tearing = false,
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
