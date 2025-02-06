{ hostName, userName, ... }:

{
  system.activationScripts.profilePicture = {
    text = ''
      mkdir -p /var/lib/AccountsService/{icons,users}
      cp /home/${userName}/Kantai/machines/${hostName}/pfp.png /var/lib/AccountsService/icons/${userName}
      echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${userName}\n" > /var/lib/AccountsService/users/${userName}
    '';
  };
}
