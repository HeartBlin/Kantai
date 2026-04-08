{
  flake.modules.nixos.theme = { config, lib, pkgs, ... }: let
    inherit (config.nimic) user;
    gtkSettings.Settings = {
      gtk-theme-name = "Adwaita-dark";
      gtk-icon-theme-name = "Adwaita";
      gtk-cursor-theme-name = "Bibata-Modern-Ice";
      gtk-cursor-theme-size = 24;
      gtk-font-name = "Cantarell 11";
      gtk-application-prefer-dark-theme = true;
    };

    iniContent = lib.generators.toINI { } gtkSettings;
    gtk2Content = ''
      gtk-theme-name="${gtkSettings.Settings.gtk-theme-name}"
      gtk-icon-theme-name="${gtkSettings.Settings.gtk-icon-theme-name}"
      gtk-cursor-theme-name="${gtkSettings.Settings.gtk-cursor-theme-name}"
      gtk-cursor-theme-size=${toString gtkSettings.Settings.gtk-cursor-theme-size}
      gtk-font-name="${gtkSettings.Settings.gtk-font-name}"
    '';
  in {
    environment = {
      sessionVariables = {
        GTK2_RC_FILES = "$HOME/.gtkrc-2.0";
      };

      systemPackages = with pkgs; [
        gnome-themes-extra
        adwaita-icon-theme
        bibata-cursors
      ];
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita";
    };

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            gtk-theme = "Adwaita-dark";
            color-scheme = "prefer-dark";
            icon-theme = "Adwaita";
            cursor-theme = "Bibata-Modern-Ice";
            font-name = "Cantarell 11";
            cursor-size = lib.gvariant.mkInt32 24;
          };
        };
      }
    ];

    hjem.users.${user}.files = {
      ".config/gtk-3.0/settings.ini".text = iniContent;
      ".config/gtk-4.0/settings.ini".text = iniContent;
      ".gtkrc-2.0".text = gtk2Content;

      # /mods and /mod_overrides are cause I mod PayDay 2
      ".config/gtk-3.0/bookmarks".text = ''
        file:///home/${user}/Documents Documents
        file:///home/${user}/Downloads Downloads
        file:///home/${user}/Pictures Pictures
        file:///home/${user}/Music Music
        file:///home/${user}/Videos Videos
        file:///mnt/intel Storage
        file:///mnt/intel/SteamLibrary/steamapps/common/PAYDAY%202/mods Mods
        file:///mnt/intel/SteamLibrary/steamapps/common/PAYDAY%202/assets/mod_overrides Mod Overrides
      '';
    };
  };
}
