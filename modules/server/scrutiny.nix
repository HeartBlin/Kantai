{
  flake.modules.nixos.server = {
    services = let
      host = "127.0.0.1";
      port = 8067;
    in {
      scrutiny = {
        enable = true;
        collector.enable = true;
        settings.web.listen = {
          inherit host port;
        };
      };
    };
  };
}
