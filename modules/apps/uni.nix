{ moduleWithSystem, ... }:

{
  flake.modules.nixos.uni = moduleWithSystem ({ self', ... }: { config, pkgs, ... }: {
    users.users.${config.nimic.user}.extraGroups = [ "wireshark" "pcap" ];
    programs = {
      wireshark.enable = true;
      tcpdump.enable = true;
    };

    environment.systemPackages = [
      pkgs.wireshark
      pkgs.aircrack-ng
      pkgs.nmap
      pkgs.dosbox
      self'.packages.ltspice
    ];
  });
}
