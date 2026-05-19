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
}
