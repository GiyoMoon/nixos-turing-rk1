{ stdenv, pkgs }:
stdenv.mkDerivation {
  pname = "uboot-sd-image";
  version = "0.1.0";
  buildCommand = ''
    mkdir -p $out/sd-image
    export img=$out/sd-image/uboot.img

    # u-boot fits in 10MB
    imageSize=$((10 * 1024 * 1024))
    truncate -s $imageSize $img

    dd if=${pkgs.ubootTuringRK1}/u-boot-rockchip.bin of=$img seek=1 bs=32k conv=notrunc
  '';
}
