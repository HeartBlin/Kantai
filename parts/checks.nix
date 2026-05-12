{ inputs, self }:

inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
  system: let
    inherit (inputs.nixpkgs.lib) getExe;
    inherit (inputs.nixpkgs.legacyPackages.${system}) pkgs;
  in {
    alejandra = pkgs.runCommand "check-alejandra" { } ''
      ${getExe self.packages.${system}.alejandra-custom} --check ${self}
      touch $out
    '';

    deadnix = pkgs.runCommand "check-deadnix" { } ''
      ${getExe pkgs.deadnix} --fail ${self}
      touch $out
    '';

    statix = pkgs.runCommand "check-statix" { } ''
      ${getExe pkgs.statix} check ${self}
      touch $out
    '';

    yamllint = pkgs.runCommand "check-yamllint" { } ''
      ${getExe pkgs.yamllint} -c ${self}/.yamllint ${self}
      touch $out
    '';
  }
)
