{ inputs }:

inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
  system: let
    inherit (inputs.nixpkgs.legacyPackages.${system}) pkgs;
    dir = ../packages;
  in
    builtins.readDir dir
    |> pkgs.lib.filterAttrs (_: type: type == "directory")
    |> builtins.mapAttrs (name: _: pkgs.callPackage "${dir}/${name}" { })
)
