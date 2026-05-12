{ lib, ... }:

{
  options.kantai = let
    mkVar = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  in {
    user = mkVar;
    email = mkVar;
    name = mkVar;
    flake = mkVar;
  };
}
