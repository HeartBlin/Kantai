{ userName, ... }:

let
  config' = ''
    Host *
      ForwardAgent no
      AddKeysToAgent no
      Compression no
      ServerAliveInterval 0
      ServerAliveCountMax 3
      HashKnownHosts no
      UserKnownHostsFile ~/.ssh/known_hosts
      ControlMaster no
      ControlPath ~/.ssh/master-%r@%n:%p
      ControlPersist no

    Host github.com
      HostName github.com
      PreferredAuthentications publickey
      IdentityFile /home/${userName}/.ssh/id_ed25519.github_auth
  '';
in {
  programs.git = {
    enable = true;
    config = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user = {
        email = "heartblin@gmail.com"; # Doxxed LEL
        name = "HeartBlin";            #
        signingkey = "/home/${userName}/.ssh/id_ed25519.github_signing.pub";
      };
    };
  };

  homix.".ssh/config".text = config';
}