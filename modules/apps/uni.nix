{ config, pkgs, self, system, ... }:

{
  users.users.${config.kantai.user}.extraGroups = [ "dialout" "libvirtd" ];
  environment.systemPackages = with pkgs; [
    self.packages.${system}.ltspice
    virtiofsd
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
  };
}
