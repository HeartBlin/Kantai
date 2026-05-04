local wp = require("_wallpaper")

local dsp = hl.dsp
local exec = dsp.exec_cmd
local window = dsp.window
local focus = dsp.focus

local audioUp = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
local audioDown = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
local audioMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
local brightnessUp = "brightnessctl set +5%"
local brightnessDown = "brightnessctl set 5%-"

-- Core
hl.bind("SUPER + Return", exec("footclient"))
hl.bind("SUPER + Space", exec("vicinae toggle"))
hl.bind("SUPER + E", exec("nautilus"))
hl.bind("SUPER + W", exec("chromium"))
hl.bind("Print", exec("hyprshot -o ~/Pictures/Screenshots -m region"))

-- Window management
hl.bind("SUPER + F", window.fullscreen())
hl.bind("SUPER + ALT + F", window.float({ action = "toggle" }))
hl.bind("SUPER + Q", window.close())
hl.bind("SUPER + SHIFT + Q", dsp.exit())

-- Wallpaper
hl.bind("ALT + E", function() wp.walk(1) end)
hl.bind("ALT + Q", function() wp.walk(-1) end)

-- Focus
hl.bind("SUPER + G", function()
  if hl.get_config("animations.enabled") then
    hl.config({
      animations = { enabled = false },
      general = { gaps_in = 0, gaps_out = 0 },
      decoration = {
        dim_inactive = false,
        blur = { enabled = false },
        shadow = { enabled = false },
        rounding = 0
      }
    })
  else
    hl.config({
      animations = { enabled = true },
      general = { gaps_in = 5, gaps_out = 10 },
      decoration = {
        dim_inactive = true,
        blur = { enabled = true },
        shadow = { enabled = true },
        rounding = 18
      }
    })
  end
end)

-- Workspaces
for i = 1, 10 do
  local key = i % 10
  hl.bind("SUPER + " .. key, focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. key, window.move({ workspace = i }))
end

-- Hardware keys
hl.bind("XF86AudioRaiseVolume", exec(audioUp), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", exec(audioDown), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", exec(brightnessUp), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec(brightnessDown), { locked = true, repeating = true })
hl.bind("XF86AudioMute", exec(audioMute), { locked = true })

-- Mouse
hl.bind("SUPER + mouse:272", window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", window.resize(), { mouse = true })
hl.bind("SUPER + mouse_up", focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_down", focus({ workspace = "e-1" }))
