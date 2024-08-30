{ buildUBoot, pkgs }:
let
  rkbin = pkgs.callPackage ../rkbin { };
in
buildUBoot {
  extraMeta.platforms = [ "aarch64-linux" ];
  defconfig = "turing-rk1-rk3588_defconfig";
  ROCKCHIP_TPL = "${rkbin}/ddr.bin";
  BL31 = "${rkbin}/bl31.elf";

  buildPhase = "make -j$(nproc)";

  patches = [ ./patches/01_rk3588-turing-rk1-pcie3.patch ];
  filesToInstall = [ "u-boot-rockchip.bin" ];
}
