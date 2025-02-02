{ role, ... }:

let
  inherit (builtins) concatStringsSep elem;
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
    ./id
    ./security
    ./nix
  ];
in {
  assertions = [
    # Role enforcement
    {
      assertion = elem role allowedRoles;
      message = ''
        Invalid role "${role}"
        Allowed roles: [ "${concatStringsSep ''" "'' allowedRoles}" ]
      '';
    }
  ];

  # Core modules import
  imports = coreImports ++ roleImport;
}