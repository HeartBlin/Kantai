{ lib, ... }:

let
  inherit (lib) mkEnableOption;
  allModules = [
    ./fish
    ./vscode
  ];
in {
  # All oprional modules, every system can choose to have them or not
  options.Kantai = {
    fish.enable = mkEnableOption "Enable the fish shell, starship prompt and direnv integration";
    vscode.enable = mkEnableOption "Enable the VSCode code editor";
  };

  imports = allModules;
}
