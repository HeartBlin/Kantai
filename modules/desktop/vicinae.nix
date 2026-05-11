{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.vicinae ];
  hjem.users.${config.kantai.user}.files.".config/vicinae/settings.json" = {
    generator = lib.generators.toJSON { };
    value = {
      "$schema" = "https://vicinae.com/schemas/config.json";
      "telemetry"."system_info" = false;
      "search_files_in_root" = false;
      "activate_on_single_click" = false;
      "escape_key_behavior" = "close_window";
      "pop_on_backspace" = true;
      "close_on_focus_loss" = false;
      "consider_preedit" = false;
      "pop_to_root_on_close" = true;
      "favicon_service" = "google";
      "keybinding" = "default";
      "font" = {
        "rendering" = "native";
        "normal" = {
          "family" = "TeX Gyre Adventor";
          "size" = 11;
        };
      };

      "theme"."dark" = {
        "name" = "vicinae-dark";
        "icon_theme" = "auto";
      };

      "launcher_window" = {
        "opacity" = 0.75;
        "blur"."enabled" = true;
        "dim_around" = true;
        "client_size_decorations" = {
          "enabled" = true;
          "rounding" = 10;
          "border_width" = 2;
        };

        "compact_mode"."enabled" = true;
        "layer_shell" = {
          "enabled" = true;
          "keyboard_interactivity" = "on_demand";
          "layer" = "top";
        };
      };
    };
  };
}
