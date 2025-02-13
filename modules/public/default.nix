{ lib, ... }:

let
  inherit (lib) mkEnableOption;
  allModules = [
    ./asus
    ./chrome
    ./fish
    ./foot
    ./hyprland
    ./lanzaboote
    ./plymouth
    ./vscode
  ];
in {
  # All oprional modules, every system can choose to have them or not
  options.Kantai = {
    asus.enable = mkEnableOption "Enables asusd and supergfxd";
    chrome.enable =
      mkEnableOption "Enables the Chrome browser (actually chromium)";
    fish.enable = mkEnableOption
      "Enables the fish shell, starship prompt and direnv integration";
    foot.enable = mkEnableOption "Enables the foot terminal emulator";
    hyprland.enable = mkEnableOption "Enables the Hyprland wayland compsitor";
    lanzaboote.enable = mkEnableOption "Provides SecureBoot support";
    plymouth.enable = mkEnableOption "Enables graphical boot";
    vscode.enable = mkEnableOption "Enables the VSCode code editor";
  };

  imports = allModules;
}
