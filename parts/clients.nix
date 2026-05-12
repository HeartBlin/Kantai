{ inputs, self }:

let
  inherit (inputs.nixpkgs.lib) filterAttrs genAttrs nixosSystem;
  system = "x86_64-linux";
  hosts =
    builtins.readDir "${self}/clients"
    |> filterAttrs (_: type: type == "directory")
    |> builtins.attrNames;
in
  genAttrs hosts (
    host:
      nixosSystem {
        inherit system;
        specialArgs = { inherit inputs self system; };
        modules = [
          # Entry point
          "${self}/clients/${host}/config.nix"
          "${self}/clients/${host}/disko.nix"

          # Modules from inputs
          inputs.disko.nixosModules.default
          inputs.hjem.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.default
          inputs.sops-nix.nixosModules.default
        ];
      }
  )
