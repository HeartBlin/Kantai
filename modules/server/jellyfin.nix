{
  flake.modules.nixos.server = { config, pkgs, ... }: {
    services = let
      inherit (config.nimic) domain;
      host = "127.0.0.1";
      port = 8096;
    in {
      jellyfin = {
        enable = true;
        user = "jellyfin";
      };

      caddy.virtualHosts."movies.${domain}" = {
        useACMEHost = "${domain}";
        extraConfig = ''
          reverse_proxy ${host}:${toString port}
          header -Server
        '';
      };
    };

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    users.users.jellyfin = {
      isSystemUser = true;
      extraGroups = [ "render" "video" "users" ];
    };
  };
}
