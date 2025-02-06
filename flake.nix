{
  description = "Unstable as @#$% dots. Powered by flake-parts";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./machines ./packages ];
      systems = import inputs.systems;
    };

  inputs = {
    ##### Inputs meant to be followed #####

    # Flake framework
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # The main NixOS repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Provides 'systems'
    systems.url = "github:nix-systems/x86_64-linux";

    ########### Everything else ###########

    # Bleeding edge kernel
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        home-manager.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Lightweight home management
    homix = {
      url = "github:sioodmy/homix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Wayland compositor
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # JS bar
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SecureBoot support
    lanzaboote = {
      url = "github:/nix-community/lanzaboote/v0.4.2";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks-nix.follows = "";
      };
    };

    # A 'nix' fork, decently faster
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix CLI helper
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}