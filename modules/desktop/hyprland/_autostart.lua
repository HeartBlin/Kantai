hl.on("hyprland.start", function()
  local exec = hl.exec_cmd

  exec("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  exec("hyprctl setcursor Bibata-Modern-Ice 24")
  exec("foot --server")
  exec("vicinae server")
  exec("awww-daemon")
end)
