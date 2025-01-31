{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./machines ];
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
    systems.url = "github:nix-systems/default";

    ########### Everything else ###########

    # A 'nix' fork, decently faster
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}