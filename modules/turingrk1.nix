{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
  uboot = pkgs.callPackage ../packages/u-boot { };
in
{
  imports = [ "${pkgs.path}/nixos/modules/installer/sd-card/sd-image.nix" ];

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ../packages/kernel { inherit inputs; });
    kernelModules = [
      "nf_tables"
      "raid1"
    ];

    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootfstype=ext4"
      "console=ttyS2,1500000"
      "console=ttyS9,115200"
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

  fileSystems = lib.mkForce {
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
    firmwareSize = 20;
    populateFirmwareCommands = "";

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';

    postBuildCommands = ''
      dd if=${uboot}/u-boot-rockchip.bin of=$img seek=1 bs=32k conv=notrunc
    '';
  };
}
