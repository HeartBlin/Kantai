let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {
    config = {
      allowAliases = false;
      allowBroken = false;
      allowUnfree = true;
      allowUnsupportedSystem = false;
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    overlays = [
      (final: _: {
        alejandra-custom = import ./packages/alejandra-custom { pkgs = final; };
        ltspice = import ./packages/ltspice { pkgs = final; };
        wallpaper-walk = import ./packages/wallpaper-walk { pkgs = final; };
      })
    ];
  };
in
  modules:
    pkgs.nixos ([
        # Nice modules
        "${sources.agenix}/modules/age.nix"
        "${sources.disko}/module.nix"
        "${sources.nix-index-database}/nixos-module.nix"

        # Nice-ish modules
        (import sources.hjem { inherit pkgs; }).nixosModules.default
        (import sources.lanzaboote { inherit pkgs; }).nixosModules.lanzaboote

        # Pass 'sources'
        { _module.args.sources = sources; }

        # Pass my custom lib and "self"
        { _module.args.lib' = import ./lib { inherit (pkgs) lib; }; }
        { _module.args.self = pkgs.lib.cleanSource ./.; }
      ]
      ++ modules)
