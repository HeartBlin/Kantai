{ inputs, lib, withSystem, self, ... }:

let
  hosts = [ "Reason" "Void" ];
  system = "x86_64-linux";
in {
  flake.nixosConfigurations = lib.genAttrs hosts (host:
    withSystem system ({ inputs', self', ... }:
      lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs inputs' self self'; };
        modules = [
          # Entry point
          "${self}/clients/${host}"

          # Modules from inputs
          inputs.agenix.nixosModules.default
          inputs.disko.nixosModules.default
          inputs.hjem.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.default
        ];
      }));
}
