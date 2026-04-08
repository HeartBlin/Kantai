{ config, inputs, lib, self, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) bool str;
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

      nvidia = {
        prime = mkOption { type = bool; };
        amdgpuBusId = mkOption { type = str; };
        nvidiaBusId = mkOption { type = str; };
        perDinam = mkOption { type = bool; };
      };

      domain = mkOption { type = str; };
      acmeEmail = mkOption { type = str; };
    };
  in {
    nixosConfigurations = lib.flip lib.mapAttrs config.nimic.nixos (_: { module }:
      lib.nixosSystem {
        modules = [ module { inherit options; } ];
        specialArgs = {
          inherit inputs self;
          inherit (inputs) secrets;
        };
      });
  };
}
