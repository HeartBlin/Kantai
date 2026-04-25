{ config, ... }:

{
  programs.git = {
    enable = true;
    config = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      user = {
        inherit (config.nimic) email name;
        signingkey = "/home/${config.nimic.user}/.ssh/gitlab";
      };
    };
  };

  hjem.users.${config.nimic.user}.files.".ssh/config".text = ''
    Host gitlab.com
      HostName gitlab.com
      User git
      IdentityFile /home/${config.nimic.user}/.ssh/gitlab
      IdentitiesOnly yes
  '';
}
