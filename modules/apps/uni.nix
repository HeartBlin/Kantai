{ pkgs, self', ... }:

{
  environment.systemPackages = with pkgs; [
    dosbox
    self'.packages.ltspice
  ];
}
