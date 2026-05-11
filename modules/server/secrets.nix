_:

{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      "restic_pass" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "nextcloud_admin_pass" = { };

      "ovh_env" = {
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "ovh/app_key" = { };
      "ovh/app_secret" = { };
      "ovh/consumer_key" = { };
      "ovh/endpoint" = { };
    };
  };
}
