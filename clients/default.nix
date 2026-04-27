{ inputs, lib, withSystem, self, ... }:

let
  hosts = [ "Reason" "Void" ];
  system = "x86_64-linux";
in {
  flake.nixosConfigurations = lib.genAttrs hosts (host:
    withSystem system ({ inputs', self', ... }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs inputs' self self';
          lib' = import "${self}/lib" { inherit (inputs.nixpkgs) lib; };
        };

        modules = [
          "${self}/clients/${host}"

          inputs.agenix.nixosModules.default
          inputs.disko.nixosModules.default
          inputs.hjem.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.default
        ];
      }));
}
