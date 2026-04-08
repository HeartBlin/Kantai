{
  flake.modules.nixos.server = { config, secrets, ... }: let
    inherit (config.nimic) domain acmeEmail;
  in {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    age.secrets.dns.file = "${secrets}/dns.age";
    services.caddy.enable = true;

    security.acme = {
      acceptTerms = true;
      defaults.email = "${acmeEmail}";
      certs.${domain} = {
        inherit domain;
        inherit (config.services.caddy) group;
        extraDomainNames = [ "*.${domain}" ];
        dnsProvider = "ovh";
        credentialsFile = config.age.secrets.dns.path;
      };
    };
  };
}
