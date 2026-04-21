{
  flake.modules.nixos.server = {
    services = let
      host = "127.0.0.1";
      port = 3001;
    in {
      uptime-kuma = {
        enable = true;
        settings = {
          "UPTIME_KUMA_HOST" = host;
          "UPTIME_KUMA_PORT" = toString port;
        };
      };
    };
  };
}
