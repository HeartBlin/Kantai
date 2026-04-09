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

    apps = {
      Reason = {
        type = "app";
        program = toString (pkgs.writeShellScript "reason" ''
          exec ${pkgs.nh}/bin/nh os switch . -u \
            --hostname Reason \
            --target-host server@reason
        '');
      };

      Void = {
        type = "app";
        program = toString (pkgs.writeShellScript "rebuild-void" ''
          exec ${pkgs.nh}/bin/nh os switch . -u \
            --hostname Void
        '');
      };
    };
  };
}
