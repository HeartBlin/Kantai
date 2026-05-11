{ config, lib, pkgs, ... }:

let
  vesktopSettings = {
    appBadge = false;
    arRPC = true;
    checkUpdates = false;
    customTitlebar = false;
    disableMinSize = true;
    tray = false;
    staticTitle = true;
    hardwareAcceleration = true;
    discordBranch = "stable";
  };

  vencordSettings = {
    autoUpdate = false;
    autoUpdateNotification = false;
    notifyAboutUpdates = false;
    plugins = {
      AnonymiseFileNames.enabled = true;
      FakeNitro.enabled = true;
    };
  };
in {
  environment.systemPackages = [
    (pkgs.vesktop.override { withSystemVencord = true; })
  ];

  hjem.users.${config.nimic.user}.files = {
    ".config/vesktop/settings.json" = {
      generator = lib.generators.toJSON { };
      value = vesktopSettings;
    };

    ".config/vesktop/settings/settings.json" = {
      generator = lib.generators.toJSON { };
      value = vencordSettings;
    };
  };
}
