{
  flake.modules.nixos.server = { config, pkgs, secrets, ... }: {
    age.secrets = {
      "restic" = {
        file = "${secrets}/restic.age";
        owner = "root";
        group = "root";
        mode = "0400";
      };

      "ovh" = {
        file = "${secrets}/ovh.age";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };

    environment.systemPackages = [ pkgs.rclone ];
    services.restic.backups = {
      vaultwarden = {
        repository = "s3:https://s3.eu-central-lz-buh-a.cloud.ovh.net/heartblin/vaultwarden";
        paths = [ "/var/local/vaultwarden/backup" ];
        initialize = true;

        passwordFile = config.age.secrets."restic".path;
        environmentFile = config.age.secrets."ovh".path;

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

        backupCleanupCommand = ''
          if [ "$EXIT_STATUS" = "0" ]; then
            ${pkgs.curl}/bin/curl -fsS -m 10 --retry 3 "https://uptime.heartblin.eu/api/push/n80OfFyn1eiSsJRTedKVDwGiG6yLI6Aw?status=up&msg=OK&ping=" > /dev/null
          fi
        '';
      };

      nextcloud = {
        repository = "s3:https://s3.eu-central-lz-buh-a.cloud.ovh.net/heartblin/nextcloud";
        paths = [ "/mnt/Nextcloud/data/heartblin/files" ];
        initialize = true;

        passwordFile = config.age.secrets."restic".path;
        environmentFile = config.age.secrets."ovh".path;

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
          if [ "$EXIT_STATUS" = "0" ]; then
            ${pkgs.curl}/bin/curl -fsS -m 10 --retry 3 "https://uptime.heartblin.eu/api/push/7Lt93e95qLTakqs594UE7NIeRRe25Lgp?status=up&msg=OK&ping=" > /dev/null
          fi
        '';
      };
    };
  };
}
