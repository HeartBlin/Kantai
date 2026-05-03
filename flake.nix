{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        darwin.follows = "";
        home-manager.follows = "";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "";
      };
    };

    hyprland.url = "github:hyprwm/hyprland";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = "";
      };
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@gitlab.com/heart.blin/nimic-agenix.git";
      flake = false;
    };
  };

  outputs = { self, ... } @ inputs: let
    lib = inputs.nixpkgs.lib;
    systems = import inputs.systems;
    forAllSystems = lib.genAttrs systems;
    p = inputs.nixpkgs.legacyPackages;
  in {
    nixosConfigurations = import ./clients { inherit inputs lib self; };
    packages = forAllSystems (
      system: import ./packages { inherit (p.${system}) pkgs; }
    );
  };
}
