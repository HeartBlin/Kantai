{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) concatStringsSep;
  inherit (config.Kantai) chrome;

  flags = concatStringsSep " " [
    "--enable-features=VaapiVideoDecodeLinuxGL"
    "--ignore-gpu-blocklist"
    "--disable-gpu"
    "--enable-zero-copy"
  ];

  chromium' = pkgs.symlinkJoin {
    name = "chromium-wrapped";
    paths = [ pkgs.chromium ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''wrapProgram $out/bin/chromium --add-flags "${flags}"'';
  };
in {
  config = mkIf chrome.enable {
    environment.systemPackages = [ chromium' ];
    programs.chromium = {
      enable = true;
      extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock Origin
      ];
    };
  };
}
