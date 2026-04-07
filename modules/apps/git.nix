{
  flake.modules.nixos.git = { config, pkgs, ... }: let
    inherit (config.nimic) user email gitName;
  in {
    environment.systemPackages = [ pkgs.jujutsu ];
    programs.git = {
      enable = true;
      config = {
        commit.gpgSign = true;
        gpg.format = "ssh";
        user = {
          inherit email;
          name = gitName;
          signingkey = "/home/${user}/.ssh/gitlab";
        };
      };
    };

    hjem.users.${user}.files = {
      ".ssh/config".text = ''
        Host gitlab.com
          HostName gitlab.com
          User git
          IdentityFile /home/${user}/.ssh/gitlab
          IdentitiesOnly yes
      '';

      ".config/jj/config.toml".text = ''
        #:schema https://docs.jj-vcs.dev/latest/config-schema.json

        [user]
        name = "${gitName}"
        email = "${email}"
      '';
    };
  };
}
