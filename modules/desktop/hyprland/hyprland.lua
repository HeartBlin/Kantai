local bind = hl.bind
local env = hl.env
local exec = hl.dsp.exec_cmd
local exec_once = hl.exec_cmd
local focus = hl.dsp.focus
local monitor = hl.monitor
local window = hl.dsp.window
local window_rule = hl.window_rule

-- SSH thingy
local xdg_dir = os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000"

-- Monitors
monitor({ output = "eDP-1", mode = "1920x1080@144", position = "0x0", scale = "1" })
monitor({ output = "", mode = "highres", position = "auto", scale = "1" })

-- Environment
env("XCURSOR_SIZE", "24")
env("HYPRCURSOR_SIZE", "24")
env("QT_QPA_PLATFORM", "wayland")
env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
env("GDK_BACKEND", "wayland,x11")
env("SDL_VIDEODRIVER", "wayland")
env("XDG_SESSION_TYPE", "wayland")
env("XDG_CURRENT_DESKTOP", "Hyprland")
env("XDG_SESSION_DESKTOP", "Hyprland")
env("QT_WAYLAND_PLATFORMTHEME", "gnome")
env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
env("MOZ_ENABLE_WAYLAND", "1")
env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
env("OZONE_PLATFORM", "wayland")
env("SSH_AUTH_SOCK", xdg_dir .. "/gcr/ssh")

-- Autostart
hl.on("hyprland.start", function ()
	exec_once("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	exec_once("hyprctl setcursor Bibata-Modern-Ice 24")
	exec_once("foot --server")
	exec_once("qs")
	exec_once("mako --default-timeout 2000 --ignore-timeout 1")
	exec_once("sleep 2 && nm-applet")
	exec_once("sleep 1.5 && blueman-applet")
	exec_once("sleep 1 && rog-control-center")
end)

-- General
hl.config({
	animations = { enabled = false },
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
          			"0xff96d988", "0xff8ccf7e", "0xff67cbe7", "0xff6cbfbf",
					"0xff71baf2", "0xffc47fd5",
				},
			},
		},
	},

	decoration = {
		dim_inactive = false,
		rounding = 0,
		blur = { enabled = false },
		shadow = { enabled = false },
	},

	input = {
		follow_mouse = 1,
		kb_layout = "ro",
		sensitivity = 0,
		touchpad = {
			clickfinger_behavior = true,
			disable_while_typing = true,
			natural_scroll = false,
			tap_to_click = true,
		},
	},

	ecosystem = { no_donation_nag = true, no_update_news = true },
	cursor = { no_hardware_cursors = 0 },
	render = { direct_scanout = 1 },
	xwayland = { force_zero_scaling = true },
	dwindle = { preserve_split = true },

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		swallow_regex = "foot",
		middle_click_paste = false,
		disable_watchdog_warning = 1
	},
})

-- Keybinds: Apps / Actions
bind("SUPER + Return", exec("footclient"))
bind("SUPER + Space", exec("rofi -config /etc/xdg/rofi/config.rasi -show drun"))
bind("SUPER + E", exec("nautilus"))
bind("SUPER + W", exec("chromium"))
bind("Print", exec("hyprshot -o ~/Pictures/Screenshots -m region"))
bind("SUPER + F", window.fullscreen())
bind("SUPER + ALT + F", window.float({ action = "toggle" }))
bind("SUPER + Q", window.close())
bind("SUPER + SHIFT + Q", hl.dsp.exit())
bind("ALT + E", exec("qs ipc call wp walk 1"))
bind("ALT + Q", exec("qs ipc call wp walk -1"))

-- Keybinds: Workspaces
for i = 1, 10 do
	local key = i % 10
	bind("SUPER + " .. key, focus({ workspace = i }))
	bind("SUPER + SHIFT + " .. key, window.move({ workspace = i }))
end

-- Keybinds: Media / Brightness
local SINK = "@DEFAULT_AUDIO_SINK@"
bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1.0 " .. SINK .. " 5%+"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", exec("wpctl set-volume -l 1.0 " .. SINK .. " 5%-"), { locked = true, repeating = true })
bind("XF86AudioMute", exec("wpctl set-mute " .. SINK .. " toggle"), { locked = true })
bind("XF86MonBrightnessUp", exec("brightnessctl set 5%+"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Keybinds: Mouse
bind("SUPER + mouse:272", window.drag(), { mouse = true })
bind("SUPER + mouse:273", window.resize(), { mouse = true })
bind("SUPER + mouse_up", focus({ workspace = "e+1" }))
bind("SUPER + mouse_down", focus({ workspace = "e-1" }))

-- Window Rules
window_rule({ name = "waydroid-fs", match = { class = "Waydroid" }, fullscreen = true })
