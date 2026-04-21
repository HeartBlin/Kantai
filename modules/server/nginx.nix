{
  flake.modules.nixos.server = { config, pkgs, secrets, ... }: let
    inherit (config.nimic) domain acmeEmail;
    privateNets = ''
      allow 100.64.0.0/10;
      allow 192.168.0.0/16;
      allow 10.0.0.0/8;
      allow 172.16.0.0/12;
      deny all;
    '';

    mkVHost = { port, extraLocConfig ? "" }: {
      useACMEHost = domain;
      forceSSL = true;
      extraConfig = privateNets;
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
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    age.secrets.dns.file = "${secrets}/dns.age";
    services.nginx = {
      enable = true;
      enableReload = true;
      package = pkgs.nginxMainline;

      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;

      # https://wiki.nixos.org/wiki/Nginx
      appendHttpConfig = ''
        map $scheme $hsts_header {
          https  "max-age=31536000; includeSubDomains; preload";
        }

        add_header Strict-Transport-Security $hsts_header always;
        add_header 'Referrer-Policy' 'no-referrer' always;
        add_header 'X-Frame-Options' 'DENY';
        add_header X-Content-Type-Options nosniff always;

        limit_req_zone $binary_remote_addr zone=auth:10m rate=10r/m;
      '';

      virtualHosts = {
        "${domain}" = mkVHost { port = 8080; };
        "movies.${domain}" = mkVHost {
          port = 8096;
          extraLocConfig = ''
            proxy_buffering off;
            client_max_body_size 100M;
          '';
        };

        "scrutiny.${domain}" = mkVHost { port = 8067; };
        "uptime.${domain}" = mkVHost {
          port = 3001;
          extraLocConfig = "proxy_buffering off;";
        };

        "vault.${domain}" = mkVHost { port = 8967; };
        "cloud.${domain}" = {
          useACMEHost = domain;
          forceSSL = true;
        };

        "_" = {
          default = true;
          rejectSSL = true;
          locations."/".return = "444";
        };
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = acmeEmail;
      certs.${domain} = {
        inherit domain;
        inherit (config.services.nginx) group;
        extraDomainNames = [ "*.${domain}" ];
        dnsProvider = "ovh";
        credentialsFile = config.age.secrets.dns.path;
      };
    };
  };
}
