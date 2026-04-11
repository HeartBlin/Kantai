{
  flake.modules.nixos.discord = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vesktop ];
  };
}
