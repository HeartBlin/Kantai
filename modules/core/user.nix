{ config, ... }:

{
  users.users.${config.kantai.user} = {
    isNormalUser = true;
    description = config.kantai.name;
    initialPassword = "password";
    extraGroups = [ "networkmanager" "video" "wheel" ];
  };

  hjem = {
    clobberByDefault = true;
    users.${config.kantai.user} = {
      inherit (config.kantai) user;
      enable = true;
      directory = "/home/${config.kantai.user}";
    };
  };
}
