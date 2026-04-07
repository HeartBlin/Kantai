{
  description = "Nimic - Unstable as @#$% dots";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.pre-commit.follows = "";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs.lib.fileset) fileFilter toList;
    import-tree = path: toList (fileFilter (file: file.hasExt "nix") path);
  in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = (import-tree ./modules) ++ (import-tree ./clients);
    };
}
