{
  flake.modules.nixos.git = { config, ... }: let
    inherit (config.nimic) user email gitName;
  in {
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

    hjem.users.${user}.files.".ssh/config".text = ''
      Host gitlab.com
        HostName gitlab.com
        User git
        IdentityFile /home/${user}/.ssh/gitlab
        IdentitiesOnly yes
    '';
  };
}
