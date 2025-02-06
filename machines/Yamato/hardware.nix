{ lib, modulesPath, pkgs, system, ... }:

let inherit (lib) mkForce;
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    initrd.luks.devices."cryptroot".device =
      "/dev/disk/by-uuid/06279896-5da7-4bd9-90b8-d74f33014996";
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/C1B5-43F3";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/" = {
      device = "/dev/disk/by-uuid/55334ac0-2c51-4b94-b2ae-b8ede5487441";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/55334ac0-2c51-4b94-b2ae-b8ede5487441";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

    "/var" = {
      device = "/dev/disk/by-uuid/55334ac0-2c51-4b94-b2ae-b8ede5487441";
      fsType = "btrfs";
      options = [ "subvol=@var" "compress=zstd" "noatime" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/55334ac0-2c51-4b94-b2ae-b8ede5487441";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/55334ac0-2c51-4b94-b2ae-b8ede5487441";
      fsType = "btrfs";
      options = [ "subvol=@swap" "noatime" ];
    };
  };

  swapDevices = [{ device = "/swap/swapfile"; }];

  networking.useDHCP = mkForce true;
  nixpkgs.hostPlatform = mkForce system;
  hardware.cpu.amd.updateMicrocode = mkForce true;
}
