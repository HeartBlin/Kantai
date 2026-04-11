{ inputs, ... }:

{
  flake.modules.nixos.core = { config, ... }: let
    inherit (config.nimic) user;
  in {
    imports = [ inputs.hjem.nixosModules.default ];
    users.users."${user}" = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "video" "wheel" ];
    };

    hjem = {
      clobberByDefault = true;
      users.${user} = {
        inherit user;
        enable = true;
        directory = "/home/${user}";
      };
    };
  };
}
