{ config, inputs, lib', pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  age.secrets = {
    endpoint.file = "${inputs.secrets}/ovh/endpoint.age";
    application-key.file = "${inputs.secrets}/ovh/application-key.age";
    application-secret.file = "${inputs.secrets}/ovh/application-secret.age";
    consumer-key.file = "${inputs.secrets}/ovh/consumer-key.age";
  };

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
      "heartblin.eu" = lib'.mkVHost { port = 8080; };
      "movies.heartblin.eu" = lib'.mkVHost {
        port = 8096;
        extraLocConfig = ''
          proxy_buffering off;
          client_max_body_size 100M;
        '';
      };

      "scrutiny.heartblin.eu" = lib'.mkVHost { port = 8067; };
      "uptime.heartblin.eu" = lib'.mkVHost {
        port = 3001;
        extraLocConfig = "proxy_buffering off;";
      };

      "vault.heartblin.eu" = lib'.mkVHost { port = 8967; };
      "cloud.heartblin.eu" = {
        useACMEHost = "heartblin.eu";
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
    defaults.email = "manea.emil@proton.me";
    certs."heartblin.eu" = {
      domain = "heartblin.eu";
      inherit (config.services.nginx) group;
      extraDomainNames = [ "*.heartblin.eu" ];
      dnsProvider = "ovh";
      credentialFiles = {
        "OVH_ENDPOINT_FILE" = config.age.secrets.endpoint.path;
        "OVH_APPLICATION_KEY_FILE" = config.age.secrets.application-key.path;
        "OVH_APPLICATION_SECRET_FILE" = config.age.secrets.application-secret.path;
        "OVH_CONSUMER_KEY_FILE" = config.age.secrets.consumer-key.path;
      };
    };
  };
}
