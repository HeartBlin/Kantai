{
  perSystem = { self', ... }: {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        deadnix.enable = true;
        statix.enable = true;
        alejandra = {
          enable = true;
          package = self'.packages.alejandra-custom;
        };
      };
    };
  };
}
