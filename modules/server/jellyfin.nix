{
  flake.modules.nixos.server = { pkgs, ... }: {
    services.jellyfin = {
      enable = true;
      user = "jellyfin";
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
