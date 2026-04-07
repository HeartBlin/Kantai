{ config, inputs, ... }:

{
  flake.diskoConfigurations.Reason = {
    disko.devices.disk.main = {
      device = "/dev/disk/by-id/ata-KINGSTON-SKC600512G_50026B7784CD5F58";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "24G";
            content.type = "swap";
          };

          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };

  flake.modules.nixos._Reason-Disko = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko = { inherit (config.flake.diskoConfigurations.Reason.disko) devices; };
  };
}
