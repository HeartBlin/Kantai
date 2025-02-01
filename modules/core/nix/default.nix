{ inputs, inputs', system, userName, ... }:

{
  # Nice nix cli helper
  programs.nh = {
    enable = true;
    package = inputs'.nh.packages.nh;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  # Specify flake location for nh
  environment.sessionVariables.NH_FLAKE = "/home/${userName}/Kantai";

  nix = {
    # Optimise store
    optimise.automatic = true;

    # Inform nixd about nixpkgs
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # Don't eat the CPU please
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 5;

    settings = {
      # Allow flakes & other experimental features
      experimental-features = [
        "flakes"
        "nix-command"
        "auto-allocate-uids"
        "cgroups"
        "no-url-literals"
      ];

      # Trusted users
      allowed-users = [ "root" "@wheel" ];
      trusted-users = [ "root" "@wheel" ];

      # Build in sandboxes
      sandbox = true;
      sandbox-fallback = false;

      # Direnv
      keep-derivations = true;
      keep-outputs = true;

      # Causes problems with nixd
      pure-eval = false;

      # Enable cgroups
      use-cgroups = true;

      # Shut up
      warn-dirty = false;

      # Optimise again
      auto-optimise-store = true;

      # Caches
      builders-use-substitutes = true;
      substituters = [
        "https://cache.nixos.org?priority=10" # Funny
        "https://nix-community.cachix.org" # Community
      ];

      # Keys for caches
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # Allow unfree
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  nixpkgs = {
    hostPlatform.system = system;
    config = {
      allowBroken = false;
      allowUnfree = true;
      enableParallelBuilding = true;
    };
  };

  system.stateVersion = "24.11";
}
