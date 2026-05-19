{ config, ... }:

{
  hjem.users.${config.kantai.user}.files.".ssh/config".text = ''
    Host github.com
      HostName github.com
      User git
      IdentityFile /home/${config.kantai.user}/.ssh/GitHubAuth
      IdentitiesOnly yes

    Host Reason
      HostName 100.64.0.1
      Port 22
      User server
      IdentityFile /home/${config.kantai.user}/.ssh/reason
      IdentitiesOnly yes
  '';
}
