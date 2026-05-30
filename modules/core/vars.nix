{ config, lib, ... }:

{
  # Small shim to avoid doing "hjem.users.${config.kantai.user}.files"
  config.hjem.users.${config.kantai.user}.files = config.kantai.home;
  options.kantai = {
    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    email = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    flake = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };

    home = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
