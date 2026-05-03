hl.window_rule({ name = "no-shadow-tiled", match = { float = false }, no_shadow = true })
hl.window_rule({ name = "immediate-exe", match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ name = "immediate-steam", match = { class = "^(steam_app).*" }, immediate = true })
hl.window_rule({ name = "waydroid-fs", match = { class = "Waydroid" }, fullscreen = true })

hl.layer_rule({ name = "vicinae-blur", match = { namespace = "vicinae" }, blur = true })
hl.layer_rule({ name = "vicinae-alpha", match = { namespace = "vicinae" }, ignore_alpha = 0 })
hl.layer_rule({ name = "vicinae-anim", match = { namespace = "vicinae" }, no_anim = true })
