{ lib, ... }:

let
  inherit (lib) mkEnableOption;
  allModules = [ ./vscode ];
in {
  # All oprional modules, every system can choose to have them or not
  options.Kantai = {
    vscode.enable = mkEnableOption "Enable the VSCode code editor";
  };

  imports = allModules;
}
