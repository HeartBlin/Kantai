_:

let
  privateNets' = ''
    allow 100.64.0.0/10;
    allow 192.168.0.0/16;
    allow 10.0.0.0/8;
    allow 172.16.0.0/12;
    deny all;
  '';

  mkVHost = { port, extraLocConfig ? "" }: {
    useACMEHost = "heartblin.eu";
    forceSSL = true;
    extraConfig = privateNets';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      extraConfig =
        extraLocConfig
        + ''
          proxy_hide_header Server;
          proxy_hide_header X-Powered-By;
          proxy_hide_header X-AspNet-Version;
        '';
    };
  };
in {
  inherit mkVHost;
}
