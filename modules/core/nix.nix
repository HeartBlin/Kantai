{
  flake.modules.nixos.core = { config, inputs, lib, pkgs, ... }: let
    registry = builtins.mapAttrs (_: flake: { inherit flake; }) inputs;
    nixPath = lib.mapAttrsToList (x: _: "${x}=flake:${x}") inputs;
  in {
    nixpkgs.config = {
      allowAliases = false;
      allowBroken = false;
      allowUnfree = true;
      allowUnsupportedSystem = false;
    };

    documentation = {
      enable = false;
      doc.enable = false;
      info.enable = false;
      man.enable = false;
      nixos.enable = false;
    };

    nix = {
      package = pkgs.nixVersions.latest;
      channel.enable = false;
      inherit registry nixPath;

      settings = {
        accept-flake-config = false;
        allow-import-from-derivation = false;
        auto-optimise-store = true;
        builders-use-substitutes = true;
        flake-registry = "";
        max-jobs = "auto";
        nix-path = nixPath;
        pure-eval = true;
        sandbox = true;
        sandbox-fallback = false;
        use-cgroups = true;
        use-xdg-base-directories = true;
        warn-dirty = false;
        experimental-features = [
          "auto-allocate-uids"
          "cgroups"
          "flakes"
          "nix-command"
          "recursive-nix"
          "git-hashing"
          "verified-fetches"
        ];

        allowed-users = [ "@wheel" ];
        trusted-users = [ "@wheel" ];

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://heartblin.cachix.org"
          "https://hyprland.cachix.org"
        ];

        trusted-substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
          "https://heartblin.cachix.org"
          "https://hyprland.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          "heartblin.cachix.org-1:f2UzaowylZ4W0ZMZuFWwrJw93vMttELCJtg6yoyFZ+o="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
    };

    programs.nh = {
      enable = true;
      inherit (config.nimic) flake;
      clean = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
