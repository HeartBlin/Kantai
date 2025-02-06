{ inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.ags = inputs.ags.lib.bundle {
      inherit pkgs;
      src = ./.;
      name = "shell";
      entry = "app.ts";
      gtk4 = false;

      extraPackages = [ pkgs.google-fonts ];
    };
  };
}
