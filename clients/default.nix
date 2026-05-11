{ inputs, self }:

let
  inherit (inputs.nixpkgs.lib) filterAttrs genAttrs mapAttrs nixosSystem;
  system = "x86_64-linux";
  hosts =
    builtins.readDir "${self}/clients"
    |> filterAttrs (_: type: type == "directory")
    |> builtins.attrNames;

  self'.packages = self.packages.${system} or { };
  inputs' =
    inputs
    |> mapAttrs (_: x: {
      packages = x.packages.${system} or { };
    });
in
  genAttrs hosts (
    host:
      nixosSystem {
        inherit system;
        specialArgs = { inherit inputs inputs' self self'; };
        modules = [
          # Entry point
          "${self}/clients/${host}/config.nix"
          "${self}/clients/${host}/disko.nix"

          # Modules from inputs
          inputs.agenix.nixosModules.default
          inputs.disko.nixosModules.default
          inputs.hjem.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.default
        ];
      }
  )
