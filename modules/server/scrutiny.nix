_:

{
  services = {
    scrutiny = {
      enable = true;
      collector.enable = true;
      settings.web.listen = {
        host = "127.0.0.1";
        port = 8067;
      };
    };
  };
}
