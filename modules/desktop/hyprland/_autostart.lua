hl.on("hyprland.start", function()
  local exec = hl.exec_cmd

  exec("hyprctl setcursor Bibata-Modern-Ice 24")
  exec("foot --server")
  exec("vicinae server")
  exec("awww-daemon")
  exec("qs")
end)
