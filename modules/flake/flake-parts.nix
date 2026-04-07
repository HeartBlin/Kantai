{ inputs, ... }:

{
  systems = [ "x86_64-linux" ];
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.disko.flakeModules.disko
    inputs.treefmt-nix.flakeModule
  ];
}
