{ lib, pkgs, ... }:

{
  services.upower.enable = true;
  environment = {
    systemPackages = [ pkgs.quickshell ];
    etc."xdg/quickshell".source = lib.cleanSourceWith {
      src = ./.;
      filter = path: _: baseNameOf path != "default.nix";
    };
  };
}
