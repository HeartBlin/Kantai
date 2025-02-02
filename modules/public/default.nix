{ lib, ... }:

let
  inherit (lib) mkEnableOption;
  allModules = [
    ./fish
    ./foot
    ./lanzaboote
    ./plymouth
    ./vscode
  ];
in {
  # All oprional modules, every system can choose to have them or not
  options.Kantai = {
    fish.enable = mkEnableOption "Enables the fish shell, starship prompt and direnv integration";
    foot.enable = mkEnableOption "Enables the foot terminal emulator";
    lanzaboote.enable = mkEnableOption "Provides SecureBoot support";
    plymouth.enable = mkEnableOption "Enables graphical boot";
    vscode.enable = mkEnableOption "Enables the VSCode code editor";
  };

  imports = allModules;
}
