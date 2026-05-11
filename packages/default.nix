inputs:

inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
  system: let
    inherit (inputs.nixpkgs.legacyPackages.${system}) pkgs;
  in
    builtins.readDir ./.
    |> pkgs.lib.filterAttrs (_: type: type == "directory")
    |> builtins.mapAttrs (name: _: pkgs.callPackage ./${name} { })
)
