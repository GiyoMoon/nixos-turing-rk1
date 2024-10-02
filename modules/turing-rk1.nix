{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  # $ uuidgen
  rootPartitionUUID = "7a684895-6ef1-4586-98d9-2d2013e98286";
in
{
  imports = [ "${pkgs.path}/nixos/modules/installer/sd-card/sd-image.nix" ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../packages/kernel { inherit inputs; });
    kernelModules = [
      "nf_tables"
      "raid1"
      "vxlan"
      "iscsi_tcp"
      "cifs"
    ];

    kernelParams = lib.mkForce [
      "root=UUID=${rootPartitionUUID}"
      "rootfstype=ext4"
      "console=ttyS0,115200"
      "loglevel=7"
    ];

    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };

    supportedFilesystems = lib.mkForce [
      "vfat"
      "fat32"
      "exfat"
      "ext4"
      "btrfs"
    ];

    initrd.includeDefaultModules = lib.mkForce false;
    initrd.availableKernelModules = lib.mkForce [
      # NVMe
      "nvme"
      # SD cards and internal eMMC drives.
      "mmc_block"
    ];

  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware = {
    deviceTree = {
      name = "rockchip/rk3588-turing-rk1.dtb";
      overlays = [ ];
    };

    firmware = [ ];
  };

  sdImage = {
    inherit rootPartitionUUID;
    compressImage = false;

    firmwarePartitionOffset = 16;
    firmwareSize = 10;
    populateFirmwareCommands = "";

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';

    postBuildCommands = ''
      dd if=${pkgs.ubootTuringRK1}/u-boot-rockchip.bin of=$img seek=1 bs=32k conv=notrunc
    '';
  };
}
