{ config, lib, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 443 ];
  };

  services.caddy = let
    mkVHost = p: "reverse_proxy http://localhost:${toString p}";
  in {
    enable = true;
    virtualHosts = {
      "http://, https://".extraConfig = "abort";
      "photos.heartblin.eu" = lib.mkIf config.services.immich.enable {
        useACMEHost = "heartblin.eu";
        extraConfig = mkVHost config.services.immich.port;
      };

      "movies.heartblin.eu" = lib.mkIf config.services.jellyfin.enable {
        useACMEHost = "heartblin.eu";
        extraConfig = mkVHost 8096; # Module doesn't easily expose port
      };

      "scrutiny.heartblin.eu" = lib.mkIf config.services.scrutiny.enable {
        useACMEHost = "heartblin.eu";
        extraConfig = mkVHost config.services.scrutiny.settings.web.listen.port;
      };

      "vault.heartblin.eu" = lib.mkIf config.services.vaultwarden.enable {
        useACMEHost = "heartblin.eu";
        extraConfig =
          mkVHost config.services.vaultwarden.config.ROCKET_PORT
          + "header_up X-Real-IP {remote_host}";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "manea.emil@proton.me";
    certs."heartblin.eu" = {
      domain = "heartblin.eu";
      inherit (config.services.caddy) group;
      extraDomainNames = [ "*.heartblin.eu" ];
      dnsProvider = "ovh";
      credentialFiles = {
        "OVH_APPLICATION_KEY_FILE" = config.sops.secrets."ovh/app_key".path;
        "OVH_APPLICATION_SECRET_FILE" = config.sops.secrets."ovh/app_secret".path;
        "OVH_CONSUMER_KEY_FILE" = config.sops.secrets."ovh/consumer_key".path;
        "OVH_ENDPOINT_FILE" = config.sops.secrets."ovh/endpoint".path;
      };
    };
  };
}
