{ config, hostName, lib, pkgs, userName, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.generators) toJSON;

  inherit (config.Kantai) vscode;

  vscode' = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      pkief.material-icon-theme
      esbenp.prettier-vscode
    ];
  };

  config' = toJSON { } {
    # Editor
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.fontLigatures" = true;
    "editor.formatOnSave" = true;
    "editor.formatOnSaveMode" = "file";
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

    # Formatters
    "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    "[javascriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };

    # Prettier
    "prettier.requireConfig" = false;
    "prettier.tabWidth" = 2;
    "prettier.semi" = true;
    "prettier.singleQuote" = false;

    # Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.serverSettings"."nixd" = {
      "formatting"."command" = [ "nixfmt" ];
      "options"."nixos"."expr" = ''
        (builtins.getFlake \"/home/${userName}/Kantai\").nixosConfigurations.${hostName}.options'';
    };

    # Telemetry
    "telemetry.telemetryLevel" = "off";

    # Terminal
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.defaultProfile.linux" =
      "${config.users.users."${userName}".shell}";

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
      [ vscode' pkgs.nixd pkgs.nixfmt-classic pkgs.nodePackages.prettier ];
    homix.".config/Code/User/settings.json".text = config';
  };
}
