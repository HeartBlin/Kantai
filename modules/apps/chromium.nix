{
  flake.modules.nixos.chromium = { config, lib, pkgs, ... }: let
    inherit (config.nimic) domain;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "ghmbeldphafepmbegfdlkpapadhbakde" # ProtonPass
      "jplgfhpmjnbigmhklmmbgecoobifkmpa" # ProtonVPN
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
    ];

    commandLineArgs = builtins.concatStringsSep " " [
      # Fuckery
      "--enable-features=${
        builtins.concatStringsSep "," [
          "ParallelDownloading"
          "FluentOverlayScrollbar"
          "FluentScrollbar"
          "EnableTabMuting"
          "GlobalMediaControlsUpdatedUI"
          "PostQuantumKyber"
        ]
      }"
    ];
  in {
    environment.systemPackages = [
      (pkgs.chromium.override {
        inherit commandLineArgs;
      })
    ];
    programs.chromium = {
      enable = true;
      inherit extensions;

      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [ "en-GB" "ro" ];
        "AutofillAddressEnabled" = false;
        "AutofillCreditCardEnabled" = false;
        "PasswordLeakDetectionEnabled" = false;
        "EnableMediaRouter" = false;
        "BookmarkBarEnabled" = true;
        "ShowHomeButton" = false;

        # Disallow imperative extension installs
        "ExtensionInstallBlocklist" = [ "*" ];
        "ExtensionInstallAllowlist" = extensions;
      };
    };

    hjem.users.${config.nimic.user}.files.".config/chromium/Default/Bookmarks" = {
      generator = lib.generators.toJSON { };
      value = {
        "version" = 1;
        "checksum" = "00000000000000000000000000000000"; # Whatever
        "roots" = {
          "bookmark_bar" = {
            "name" = "Bookmarks Bar";
            "type" = "folder";
            "children" = [
              {
                "name" = "Selfhosted";
                "type" = "folder";
                "children" = [
                  {
                    "name" = "Glance";
                    "url" = "https://${domain}";
                    "type" = "url";
                  }
                  {
                    "name" = "Jellyfin";
                    "url" = "https://movies.${domain}";
                    "type" = "url";
                  }
                  {
                    "name" = "Nextcloud";
                    "url" = "https://cloud.${domain}";
                    "type" = "url";
                  }
                  {
                    "name" = "Scrutiny";
                    "url" = "https://scrutiny.${domain}";
                    "type" = "url";
                  }
                  {
                    "name" = "Uptime";
                    "url" = "https://uptime.${domain}";
                    "type" = "url";
                  }
                  {
                    "name" = "VaultWarden";
                    "url" = "https://vault.${domain}";
                    "type" = "url";
                  }
                ];
              }
              {
                "name" = "YouTube";
                "url" = "https://youtube.com";
                "type" = "url";
              }
              {
                "name" = "GitLab";
                "url" = "https://gitlab.com";
                "type" = "url";
              }
              {
                "name" = "Teams";
                "url" = "https://teams.microsoft.com/v2/";
                "type" = "url";
              }
              {
                "name" = "Options";
                "url" = "https://search.nixos.org/options";
                "type" = "url";
              }
              {
                "name" = "Packages";
                "url" = "https://search.nixos.org/packages";
                "type" = "url";
              }
            ];
          };
          "other" = {
            "name" = "Other Bookmarks";
            "type" = "folder";
            "children" = [ ];
          };
          "synced" = {
            "name" = "Mobile Bookmarks";
            "type" = "folder";
            "children" = [ ];
          };
        };
      };
    };
  };
}
