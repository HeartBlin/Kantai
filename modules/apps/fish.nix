{ config, pkgs, ... }:

{
  environment.variables.TMPDIR = "/tmp";
  users.users.${config.nimic.user}.shell = pkgs.fish;
  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        set -gx TMPDIR /tmp
      '';

      shellAliases = {
        ls = "${pkgs.eza}/bin/eza -l --icons --git";
        Reason = "nh os switch --file /etc/nixos/clients/Reason --target-host server@reason --hostname Reason";
        Void = "nh os switch --file /etc/nixos/clients/Void --hostname Void";
      };
    };

    starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_status$character";
        add_newline = false;
        directory.disabled = false;
        character = {
          disabled = false;
          success_symbol = "[λ](bold purple)";
          error_symbol = "[λ](bold red)";
        };
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      flags = [ "--cmd cd" ];
    };

    nix-index-database.comma.enable = true;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
