{ self, ... }:

{
  perSystem = { pkgs, ... }: {
    packages = {
      alejandra-custom =
        pkgs.callPackage "${self}/packages/alejandra-custom" { };
    };
  };
}
