{ lib }:

let
  vhostLib = import ./mkVHost.nix { };
  hyprconfLib = import ./toHyprconf.nix { inherit lib; };
in {
  inherit (vhostLib) mkVHost;
  inherit (hyprconfLib) toHyprconf;
}
