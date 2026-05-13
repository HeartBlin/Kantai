{ inputs, self }:

inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
  system: let
    inherit (inputs.nixpkgs.lib) generators getExe;
    inherit (inputs.nixpkgs.legacyPackages.${system}) pkgs;

    yamllintConfig =
      builtins.toFile "yamllint.yaml"
      (generators.toYAML { } {
        extends = "default";
        ignore = [ "**/*sops*" "**/*secrets*" ];
        rules = {
          brackets = {
            min-spaces-inside = 0;
            max-spaces-inside = 1;
          };
          document-start = "disable";
          truthy.allowed-values = [ "true" "false" "on" ];
        };
      });
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
      ${getExe pkgs.yamllint} -c ${yamllintConfig} ${self}
      touch $out
    '';
  }
)
