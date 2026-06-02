{ pkgs, ... }:

{
  security.pam.services = {
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };

  services = {
    displayManager.gdm.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
  };

  # FIX: https://github.com/NixOS/nixpkgs/issues/523332
  environment.sessionVariables.XDG_DATA_DIRS = [ "${pkgs.gdm}/share" ];
  services.displayManager.gdm.settings.debug.Enable = true;
  environment.systemPackages = [ pkgs.gnome-session ];
}
