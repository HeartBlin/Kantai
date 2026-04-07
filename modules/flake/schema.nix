{ config, inputs, lib, self, ... }:

{
  options.nimic.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule {
      options.module = lib.mkOption { type = lib.types.deferredModule; };
    });
  };

  config.flake = {
    nixosConfigurations = lib.flip lib.mapAttrs config.nimic.nixos (_: { module }:
      lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [ module ];
      });
  };
}
