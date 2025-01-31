{ role, ... }:

let
  inherit (builtins) concatStringsSep elem;
  allowedRoles = [ "desktop" "laptop" "server" ];

  roleImport = 
    if role == "desktop" then [ ./roles/desktop ]
    else if role == "laptop" then [ ./roles/laptop ]
    else if role == "server" then [ ./roles/server ]
    else [ ];

  coreImports = [
    ./security
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

  imports = coreImports ++ roleImport;
}