{ lib, ... }:

{
  options.nimic = let
    mkVar = lib.mkOption {
      type = lib.types.str;
      default = "unset";
    };
  in {
    user = mkVar;
    email = mkVar;
    name = mkVar;
  };
}
