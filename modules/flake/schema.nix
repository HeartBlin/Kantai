{ config, inputs, lib, self, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  options.nimic = {
    nixos = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.submodule {
        options.module = lib.mkOption { type = lib.types.deferredModule; };
      });
    };
  };

  config.flake = let
    options.nimic = {
      email = mkOption { type = str; };
      flake = mkOption { type = str; };
      gitName = mkOption { type = str; };
      user = mkOption { type = str; };
    };
  in {
    nixosConfigurations = lib.flip lib.mapAttrs config.nimic.nixos (_: { module }:
      lib.nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [ module { inherit options; } ];
      });
  };
}
