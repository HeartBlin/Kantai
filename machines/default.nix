{ inputs, self, withSystem, ... }:

let
  # Create systems
  mkSystem = {
    hostName, role,
    userName, prettyName ? userName,
    system ? "x86_64-linux"
  }: withSystem system ( { inputs', self', ... }: let
      inherit (inputs.nixpkgs.lib) nixosSystem;
      args = { inherit hostName role userName prettyName system inputs inputs' self self'; };
    in nixosSystem {
      specialArgs = args;

      modules = [
        # Modules from inputs
        inputs.chaotic.nixosModules.default
        inputs.homix.nixosModules.default
	      inputs.lix.nixosModules.default

        # Paths
        "${self}/machines/${hostName}/config.nix"
        "${self}/machines/${hostName}/hardware.nix"
        "${self}/modules/public"    # Modules for all roles, enabled through host-specific.nix
        "${self}/modules/core"      # Role-dependent modules, forced
      ];
    }
  );
in {
  flake.nixosConfigurations = {
    "Yamato" = mkSystem {
      hostName = "Yamato";
      role = "laptop";
      userName = "heartblin";
      prettyName = "HeartBlin";
      system = "x86_64-linux";
    };
  };
}
