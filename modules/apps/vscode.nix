{ config, pkgs, self', ... }:

let
  settingsJSON = builtins.toJSON {
    # Bread.
    "breadcrumbs.icons" = false;

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
    "workbench.colorTheme" = "Dark+";
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
    "errorLens.gutterIconsEnabled" = true;
    "errorLens.messageBackgroundMode" = "message";

    # Language Server - Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nil";
    "nix.serverSettings"."nil"."formatting"."command" = [ "alejandra" ];
    "nix.hiddenLanguageServerErrors" = [
      "textDocument/documentSymbol"
      "textDocument/formatting"
    ];

    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };

    # Language Server - C/C++
    "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
    "clangd.arguments" = [
      "--background-index"
      "--clang-tidy"
      "--header-insertion=iwyu"
      "--completion-style=detailed"
      "--function-arg-placeholders"
      "--fallback-style=Google"
    ];

    "[c]" = {
      "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave"."source.fixAll.clangd" = "explicit";
    };

    "[cpp]" = {
      "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "editor.formatOnSave" = true;
      "editor.codeActionsOnSave"."source.fixAll.clangd" = "explicit";
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
  };
in {
  fonts.packages = [ pkgs.googlesans-code ];
  hjem.users.${config.nimic.user}.files = {
    ".vscode/argv.json".text = argvJSON;
    ".config/Code/User/settings.json".text = settingsJSON;
    ".config/Code/User/keybindings.json".text = keybindJSON;
  };

  environment.systemPackages = with pkgs; [
    # Nix tools
    nil
    self'.packages.alejandra-custom
    deadnix
    statix
    direnv

    # C/C++ tools
    clang
    clang-tools
    ninja

    # Build systems
    meson
    muon

    # Extensions
    (vscode-with-extensions.override {
      inherit vscode;
      vscodeExtensions = with pkgs.vscode-extensions;
        [
          # Nix
          jnoortheen.nix-ide
          mkhl.direnv

          # C/C++
          llvm-vs-code-extensions.vscode-clangd

          # Lua
          sumneko.lua

          # Build systems
          mesonbuild.mesonbuild

          # UI / UX
          pkief.material-icon-theme
          usernamehw.errorlens

          # Origin
          gitlab.gitlab-workflow
          github.vscode-pull-request-github
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "copilot-chat";
            publisher = "github";
            version = "0.43.0";
            sha256 = "sha256-iKDRDqQ8qJe2c4SQJBiJLCEtmVmcci6753+I7uH7YVk=";
          }
        ];
    })
  ];
}
