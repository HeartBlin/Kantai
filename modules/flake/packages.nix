{ self, ... }:

{
  perSystem = { pkgs, ... }: {
    packages = {
      alejandra-custom =
        pkgs.callPackage "${self}/packages/alejandra-custom" { };
      ltspice =
        pkgs.callPackage "${self}/packages/ltspice" { };
      wallpaper-walk =
        pkgs.callPackage "${self}/packages/wallpaper-walk" { };
    };
  };
}
