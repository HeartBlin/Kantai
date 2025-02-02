{ config, hostName, lib, pkgs, userName, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.generators) toJSON;

  inherit (config.Kantai) vscode;

  vscode' = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      pkief.material-icon-theme
    ];
  };

  config' = toJSON { } {
    # Editor
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.fontLigatures" = true;
    "editor.formatOnSave" = true;
    "editor.guides.bracketPairs" = true;
    "editor.guides.indentation" = true;
    "editor.inlineSuggest.enabled" = true;
    "editor.linkedEditing" = true;
    "editor.lineHeight" = 22;
    "editor.minimap.enabled" = false;
    "editor.renderLineHighlight" = "all";
    "editor.semanticHighlighting.enabled" = true;
    "editor.showUnused" = true;
    "editor.smoothScrolling" = true;
    "editor.tabCompletion" = "on";
    "editor.tabSize" = 2;
    "editor.trimAutoWhitespace" = true;

    # Explorer
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;

    # Files
    "files.insertFinalNewline" = false;
    "files.trimTrailingWhitespace" = true;
    "files.exclude" = { "tsconfig.json" = true; };

    # Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.serverSettings"."nixd" = {
      "formatting"."command" = [ "nixfmt" ];
      "options"."nixos"."expr" = ''(builtins.getFlake \"/home/${userName}/Kantai\").nixosConfigurations.${hostName}.options'';
    };

    # Telemetry
    "telemetry.telemetryLevel" = "off";

    # Terminal
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.defaultProfile.linux" = "${config.users.users."${userName}".shell}";

    # Window
    "window.autoDetectColorScheme" = true;
    "window.experimentalControlOverlay" = false;
    "window.dialogStyle" = "custom";
    "window.menuBarVisibility" = "toggle";
    "window.titleBarStyle" = "custom";

    # Workbench
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.layoutControl.enabled" = false;
    "workbench.preferredDarkColorTheme" = "Default Dark+";
    "workbench.preferredLightColorTheme" = "Default Dark+";
    "workbench.sideBar.location" = "left";
    "workbench.startupEditor" = "none";
  };
in {
  config = mkIf vscode.enable {
    environment.systemPackages =
      [ vscode' pkgs.nixd pkgs.nixfmt-classic ];
    homix.".config/Code/User/settings.json".text = config';
  };
}
