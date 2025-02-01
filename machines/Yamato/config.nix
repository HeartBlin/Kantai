{ config, hostName, pkgs, prettyName, userName, ... }:

{
  Kantai = {
    fish.enable = true;
    foot.enable = true;
    vscode.enable = true;
  };

  networking.hostName = hostName;
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

  users.users."${userName}"= {
    description = prettyName;
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
