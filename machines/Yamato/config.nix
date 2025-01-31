{ config, hostname, lib, pkgs, prettyUsername, username, ... }:

{
  Kantai = {
    vscode.enable = true;
  };

  networking.hostName = hostname;
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Bucharest";

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;
    };
  }; 

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users."${username}"= {
    description = prettyUsername;
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" ]; 
    homix = true;
    packages = with pkgs; [
      chromium
      neovim
      git
    ];
  };
}
