{ pkgs, ... }:

{
  Kantai = {
    # Core
    nvidia = {
      enable = true;
      busIDs = {
        amd = "PCI:6:0:0";
        nvidia = "PCI:1:0:0";
      };
    };

    # Public
    asus.enable = true;
    chrome.enable = true;
    fish.enable = true;
    foot.enable = true;
    hyprland.enable = true;
    lanzaboote.enable = true;
    plymouth.enable = false;
    vscode.enable = true;
  };

  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Bucharest";

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

}
