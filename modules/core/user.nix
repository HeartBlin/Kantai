{ config, ... }:

{
  users.users.${config.nimic.user} = {
    isNormalUser = true;
    description = config.nimic.name;
    initialPassword = "password";
    extraGroups = [ "networkmanager" "video" "wheel" ];
  };

  hjem = {
    clobberByDefault = true;
    users.${config.nimic.user} = {
      inherit (config.nimic) user;
      enable = true;
      directory = "/home/${config.nimic.user}";
    };
  };
}
