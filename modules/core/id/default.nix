{ hostName, prettyName, userName, ... }:

{
  networking.hostName = hostName;
  users.users."${userName}"= {
    description = prettyName;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" ];
    homix = true;
  };
}