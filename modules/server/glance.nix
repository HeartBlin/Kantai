{
  flake.modules.nixos.server = { config, ... }: {
    services = let
      inherit (config.nimic) domain;
      host = "127.0.0.1";
      port = 8080;
    in {
      glance = {
        enable = true;
        settings = {
          server = { inherit host port; };

          theme = {
            background-color = "240 2 10";
            primary-color = "218 68 78";
            contrast-multiplier = 1.1;
          };

          branding = {
            hide-footer = true;
          };

          pages = [
            {
              name = "Home";
              hide-desktop-navigation = true;
              show-mobile-header = false;
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "clock";
                      hour-format = "24h";
                      timezones = [
                        {
                          timezone = "Asia/Seoul";
                          label = "Seoul";
                        }
                        {
                          timezone = "America/Panama";
                          label = "Panama";
                        }
                        {
                          timezone = "America/Phoenix";
                          label = "Phoenix";
                        }
                      ];
                    }
                    { type = "calendar"; }
                    {
                      type = "weather";
                      location = "Cluj-Napoca, Romania";
                      units = "metric";
                      hour-format = "24h";
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    { type = "server-stats"; }
                    {
                      type = "monitor";
                      title = "Services";
                      sites = [
                        {
                          title = "Jellyfin";
                          url = "https://movies.${domain}";
                          icon = "si:jellyfin";
                        }
                        {
                          title = "Nextcloud";
                          url = "https://cloud.${domain}";
                          icon = "si:nextcloud";
                        }
                        {
                          title = "Scrutiny";
                          url = "https://scrutiny.${domain}";
                          icon = "si:linuxfoundation";
                        }
                        {
                          title = "Uptime Kuma";
                          url = "https://uptime.${domain}";
                          icon = "si:uptimekuma";
                        }
                        {
                          title = "Vaultwarden";
                          url = "https://vault.${domain}";
                          icon = "si:bitwarden";
                        }
                      ];
                    }
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "rss";
                      title = "News";
                      style = "vertical-list";
                      limit = 16;
                      collapse-after = 8;
                      feeds = [
                        {
                          title = "Phoronix";
                          url = "https://www.phoronix.com/rss.php";
                        }
                        {
                          title = "LWN";
                          url = "https://lwn.net/headlines/rss";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
      };

      caddy.virtualHosts."${domain}" = {
        useACMEHost = "${domain}";
        extraConfig = ''
          reverse_proxy ${host}:${toString port}
          header -Server
        '';
      };
    };
  };
}
