{ inputs, ... }:

{
  flake.modules.nixos.core = { config, pkgs, ... }: let
    inherit (config.nimic) user;
  in {
    imports = [ inputs.hjem.nixosModules.default ];
    users.users."${user}" = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "video" "wheel" "libvirtd" "kvm" ];
    };

    hjem = {
      clobberByDefault = true;
      linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      users.${user} = {
        inherit user;
        enable = true;
        directory = "/home/${user}";
      };
    };
  };
}
