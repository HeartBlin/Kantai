{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rclone ];
  services.restic.backups = {
    vaultwarden = {
      repository = "s3:https://s3.eu-central-lz-buh-a.cloud.ovh.net/heartblin/vaultwarden";
      paths = [ "/var/local/vaultwarden/backup" ];
      initialize = true;

      passwordFile = config.sops.secrets."restic_pass".path;
      environmentFile = config.sops.secrets."ovh_env".path;

      timerConfig = {
        OnCalendar = "*-*-* 01:00:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };

      extraBackupArgs = [ "--compression max" ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 3"
        "--keep-monthly 3"
      ];
    };

    nextcloud = {
      repository = "s3:https://s3.eu-central-lz-buh-a.cloud.ovh.net/heartblin/nextcloud";
      paths = [ "/mnt/Nextcloud/data/heartblin/files" ];
      initialize = true;

      passwordFile = config.sops.secrets."restic_pass".path;
      environmentFile = config.sops.secrets."ovh_env".path;

      timerConfig = {
        OnCalendar = "*-*-* 04:00:00";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };

      extraBackupArgs = [ "--compression max" ];

      pruneOpts = [
        "--keep-last 2"
        "--keep-monthly 1"
      ];

      backupPrepareCommand = ''
        ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --on || \
          { echo "Failed to enable maintenance mode. Aborting backup." >&2; exit 1; }
      '';

      backupCleanupCommand = ''
        ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --off
      '';
    };
  };
}
