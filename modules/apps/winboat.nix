{
  flake.modules.nixos.winboat = { config, pkgs, ... }: {
    users.users.${config.nimic.user}.extraGroups = [ "libvirtd" "kvm" ];
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
      };

      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };
    };

    environment.systemPackages = [
      pkgs.winboat
      pkgs.dive
      pkgs.podman-tui
      pkgs.podman-compose
    ];
  };
}
