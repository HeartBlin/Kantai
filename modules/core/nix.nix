{ config, inputs, lib, pkgs, ... }:

{
  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  nixpkgs.config = {
    allowAliases = false;
    allowBroken = false;
    allowUnfree = true;
    allowUnsupportedSystem = false;
    nvidia.acceptLicense = true;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: { inherit flake; }) inputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;

    settings = {
      flake-registry = "";
      nix-path = config.nix.nixPath;

      auto-optimise-store = true;
      builders-use-substitutes = true;
      max-jobs = "auto";
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
        "pipe-operators"
      ];

      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];

      substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  environment.defaultPackages = [ ];
  programs.nh = {
    enable = true;
    inherit (config.kantai) flake;
    clean = {
      enable = true;
      dates = "weekly";
    };
  };
}
