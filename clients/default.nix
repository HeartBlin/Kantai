{ inputs, self }:

let
  lib = inputs.nixpkgs.lib;
  system = "x86_64-linux";
  hosts =
    builtins.readDir "${self}/clients"
    |> lib.filterAttrs (_: type: type == "directory")
    |> builtins.attrNames;

  self'.packages = self.packages.${system} or { };
  inputs' =
    inputs
    |> lib.mapAttrs (_: x: {
      packages = x.packages.${system} or { };
    });
in
  lib.genAttrs hosts (
    host:
      lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs inputs' self self'; };
        modules = [
          # Entry point
          "${self}/clients/${host}/config.nix"

          # Modules from inputs
          inputs.agenix.nixosModules.default
          inputs.disko.nixosModules.default
          inputs.hjem.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.default
        ];
      }
  )
