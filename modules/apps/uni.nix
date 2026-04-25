{ config, pkgs, ... }:

{
  users.users.${config.nimic.user}.extraGroups = [ "wireshark" "pcap" ];
  programs = {
    wireshark.enable = true;
    tcpdump.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wireshark
    aircrack-ng
    nmap
    dosbox
    ltspice
  ];
}
