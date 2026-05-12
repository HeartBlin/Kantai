{ config, lib, pkgs, self, system, ... }:

let
  settingsJSON = builtins.toJSON {
    # Bread.
    "breadcrumbs.icons" = false;

    # Chat - I like it autocorrecting... in the best case
    "chat.disableAIFeatures" = false;

    # Editor - behavioural
    "editor.accessibilitySupport" = "off";
    "editor.guides.bracketPairs" = true;
    "editor.wordWrap" = "on";

    # Editor - appearance
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.fontFamily" = "'Google Sans Code', 'monospace'";
    "editor.fontLigatures" = true;
    "editor.minimap.enabled" = false;
    "editor.scrollbar.horizontal" = "hidden";
    "editor.smoothScrolling" = true;

    # Explorer
    "explorer.compactFolders" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.fileNesting.enabled" = true;
    "explorer.fileNesting.patterns"."flake.nix" = "flake.lock";

    # Files
    "files.autoSave" = "onWindowChange";
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;
    "files.watcherExclude"."**/.direnv/**" = true;

    # Search
    "search.exclude" = {
      "**/.direnv" = true;
      "**/result" = true;
      "**/result-*" = true;
    };

    # Terminal
    "terminal.integrated.fontFamily" = "'Google Sans Code', 'monospace'";
    "terminal.integrated.gpuAcceleration" = "on";
    "terminal.integrated.stickyScroll.enabled" = false;
    "terminal.integrated.shellIntegration.enabled" = false;
    "terminal.integrated.defaultProfile.linux" = "fish";
    "terminal.integrated.profiles.linux"."fish" = {
      "path" = "/run/current-system/sw/bin/fish";
      "args" = [ "-i" ];
    };

    # Window
    "window.dialogStyle" = "custom";
    "window.menuBarVisibility" = "toggle";
    "window.titleBarStyle" = "native";

    # Workbench
    "workbench.colorTheme" = "Default Dark+";
    "workbench.editor.empty.hint" = "hidden";
    "workbench.editor.enablePreview" = true;
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.layoutControl.enabled" = false;
    "workbench.startupEditor" = "none";
    "workbench.tree.indent" = 16;
    "workbench.tree.renderIndentGuides" = "none";

    # Telemetry
    "telemetry.telemetryLevel" = "off";
    "extensions.autoCheckUpdates" = false;
    "extensions.autoUpdate" = false;
    "update.mode" = "none";
    "update.showReleaseNotes" = false;

    # Extensions
    "direnv.restart.automatic" = true;
    "direnv.path.executable" = "${lib.getExe pkgs.direnv}";
    "errorLens.gutterIconsEnabled" = true;
    "errorLens.messageBackgroundMode" = "message";

    # Language Server - Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${lib.getExe pkgs.nil}";
    "nix.serverSettings"."nil"."formatting"."command" = [ "${lib.getExe self.packages.${system}.alejandra-custom}" ];
    "nix.hiddenLanguageServerErrors" = [
      "textDocument/documentSymbol"
      "textDocument/formatting"
    ];

    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };

    # Language Server - C/C++
    "C_Cpp.clang_format_fallbackStyle" = "Google";
    "[c]" = {
      "editor.defaultFormatter" = "ms-vscode.cpptools";
      "editor.formatOnSave" = true;
    };

    "[cpp]" = {
      "editor.defaultFormatter" = "ms-vscode.cpptools";
      "editor.formatOnSave" = true;
    };

    # Language Server - Lua
    "Lua.format.enable" = true;
    "Lua.format.defaultConfig" = {
      "indent_style" = "space";
      "indent_size" = "2";
      "continuation_indent_size" = "2";
      "max_line_length" = "120";
      "quote_style" = "double";
      "call_arg_parentheses" = "Always";
    };

    "[lua]" = {
      "editor.defaultFormatter" = "sumneko.lua";
      "editor.formatOnSave" = true;
    };

    # Language Server - Meson
    "mesonbuild.linting.enabled" = true;
    "mesonbuild.muonPath" = "${pkgs.muon}/bin/muon";
    "mesonbuild.mesonPath" = "${pkgs.meson}/bin/meson";
    "[meson]"."editor.formatOnSave" = true;
  };

  keybindJSON = builtins.toJSON [
    {
      key = "ctrl+l";
      command = "workbench.action.terminal.clear";
      when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
    }
  ];

  argvJSON = builtins.toJSON {
    "enable-crash-reporter" = false;
    "crash-reporter-id" = "00000000-0000-0000-0000-000000000000";
    "password-store" = "gnome-libsecret";
    "enable-proposed-api" = [ "github.copilot-chat" ];
  };
in {
  fonts.packages = [ pkgs.googlesans-code ];
  hjem.users.${config.kantai.user}.files = {
    ".vscode-oss/argv.json".text = argvJSON;
    ".config/VSCodium/User/settings.json".text = settingsJSON;
    ".config/VSCodium/User/keybindings.json".text = keybindJSON;
  };

  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with pkgs.vscode-extensions;
        [
          # Nix
          jnoortheen.nix-ide
          mkhl.direnv

          # C/C++
          ms-vscode.cpptools
          platformio.platformio-vscode-ide

          # Lua
          sumneko.lua

          # Build systems
          mesonbuild.mesonbuild

          # UI / UX
          pkief.material-icon-theme
          usernamehw.errorlens

          # Origin
          github.vscode-pull-request-github
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "copilot-chat";
            publisher = "github";
            version = "0.40.0";
            sha256 = "sha256-7iFLGF9lVNZDXnrJjoXdYz7gA6YDLciwZf4/lF8sYu4=";
          }
        ];
    })
  ];
}
