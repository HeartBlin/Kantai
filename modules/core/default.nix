{ config, lib, role, ... }:

let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str;
  inherit (builtins) concatStringsSep elem;
  inherit (config.Kantai) nvidia;
  allowedRoles = [ "desktop" "laptop" "server" ];

  # Import only the role definition of the correct role
  roleImport =
    if role == "desktop" then [ ./roles/desktop ]
    else if role == "laptop" then [ ./roles/laptop ]
    else if role == "server" then [ ./roles/server ]
    else [ ];

  # Every system gets these
  coreImports = [
    ./boot
    ./git
    ./hardware/nvidia.nix
    ./id
    ./security
    ./nix
  ];
in {
  config.assertions = [
    # Role enforcement
    {
      assertion = elem role allowedRoles;
      message = ''
        Role configuration error:
          - A valid role MUST be set
          - Allowed roles: [ "${concatStringsSep ''" "'' allowedRoles}" ]
          Current value:
          - Role: ${role}
      '';
    }

    # Laptops with NVIDIA GPUs should specify BusIDs
    {
      assertion = (
        (role != "laptop" || !nvidia.enable) ||
        (nvidia.busIDs.amd != "PCI:0:0:0" && nvidia.busIDs.nvidia != "PCI:0:0:0")
      );
      message = ''
        Laptop NVIDIA configuration error:
          - Must set NVIDIA GPU ID
          - Must set one integrated GPU (AMD for now)
          Current values:
          - NVIDIA: ${nvidia.busIDs.nvidia} ${lib.optionalString (nvidia.busIDs.nvidia == "PCI:0:0:0") "(unset)"}
          - AMD: ${nvidia.busIDs.amd} ${lib.optionalString (nvidia.busIDs.amd == "PCI:0:0:0") "(unset)"}
      '';
    }
  ];

  # Core modules import
  imports = coreImports ++ roleImport;

  # Options
  options.Kantai.nvidia = {
    enable = mkEnableOption "Enables NVIDIA drivers";
    busIDs = {
      amd = mkOption {
        type = str;
        default = "PCI:0:0:0";
        description = "ID of AMD GPU";
      };

      nvidia = mkOption {
        type = str;
        default = "PCI:0:0:0";
        description = "ID of Nvidia GPU";
      };
    };
  };
}