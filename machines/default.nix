{ inputs, self, withSystem, ... }:

let
  mkSystem = {
    hostname, role,
    username, prettyUsername ? username,
    system ? "x86_64-linux"
  }: withSystem system ( { inputs', self', ... }: let 
      inherit (inputs.nixpkgs.lib) nixosSystem;
      args = { inherit hostname role username prettyUsername system inputs inputs' self self'; };
    in nixosSystem {
      specialArgs = args;
    
      modules = [
        # Modules from inputs
        inputs.chaotic.nixosModules.default
        inputs.lix.nixosModules.default

        # Paths
        "${self}/machines/${hostname}/config.nix"
        "${self}/machines/${hostname}/hardware.nix"
      ];
    }
  );
in {
  flake.nixosConfigurations = {
    Yamato = mkSystem {
      hostname = "Yamato";
      role = "laptop";
      username = "heartblin";
      prettyUsername = "HeartBlin";
      system = "x86_64-linux";
    };
  };
}