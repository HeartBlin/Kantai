{
  flake.modules.nixos.vicinae = { config, lib, pkgs, ... }: {
    environment.systemPackages = [ pkgs.vicinae ];
    hjem.users.${config.nimic.user}.files.".config/vicinae/settings.json" = {
      generator = lib.generators.toJSON { };
      value = {
        "$schema" = "https://vicinae.com/schemas/config.json";
        "close_on_focus_loss" = true;
        "consider_preedit" = false;
        "pop_to_root_on_close" = true;
        "favicon_service" = "google";
        "keybinding" = "default";
        "font"."normal" = {
          "family" = "TeX Gyre Adventor";
          "size" = 11;
        };
        "launcher_window" = {
          "opacity" = 0.75;
          "client_size_decorations"."enabled" = true;
        };
      };
    };
  };
}
