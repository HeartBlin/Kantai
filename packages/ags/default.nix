{ inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.ags = inputs.ags.lib.bundle {
      inherit pkgs;
      src = ./.;
      name = "shell";
      entry = "main.ts";
      gtk4 = false;
    };
  };
}
