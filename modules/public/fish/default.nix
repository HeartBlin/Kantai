{ config, lib, pkgs, userName, ... }:

let
  inherit (lib) getExe mkIf;
  inherit (config.Kantai) fish;
in {
  config = mkIf fish.enable {
    # Set the users shell to 'fish'
    users.users."${userName}".shell = pkgs.fish;
    programs = {
      fish = {
        enable = true;
        shellAliases = {
          ls = "${pkgs.eza}/bin/eza -l";

          # Git commands
          ga = "git add .";
          gc = "git commit -m";
          gp = "git push";
          gs = "git status";
        };

        interactiveShellInit = ''
          set fish_greeting

          function starship_transient_prompt_func
            ${getExe pkgs.starship} module character
          end

          function .
            nix shell nixpkgs#$argv[1]
          end

          function fish_command_not_found
            echo Did not find command: $argv[1]
          end

          enable_transience
        '';
      };

      # Custom prompt
      starship = {
        enable = true;
        settings = {
          add_newline = false;
          directory.disabled = false;
          character = {
            disabled = false;
            success_symbol = "[λ](bold purple)";
            error_symbol = "[λ](bold red)";
          };
        };
      };

      # Integrate direnv
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
