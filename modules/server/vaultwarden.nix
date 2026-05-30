_:

{
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    config = {
      DOMAIN = "https://vault.heartblind.eu";
      SIGNUPS_ALLOWED = "false";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "8967";

      ROCKET_LOG = "critical";

      SHOW_PASSWORD_HINT = "false";
      INVITATIONS_ALLOWED = "false";
    };
  };
}
