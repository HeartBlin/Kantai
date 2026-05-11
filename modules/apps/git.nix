{ config, ... }:

{
  programs.git = {
    enable = true;
    config = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      user = {
        inherit (config.kantai) email name;
        signingkey = "/home/${config.kantai.user}/.ssh/GitHubSign";
      };
    };
  };

  hjem.users.${config.kantai.user}.files.".ssh/config".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile /home/${config.kantai.user}/.ssh/GitHubAuth
      IdentitiesOnly yes
  '';
}
