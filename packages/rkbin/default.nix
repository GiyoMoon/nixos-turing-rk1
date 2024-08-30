{ stdenv }:
let
  bl31 = ./rk3588_bl31_v1.45.elf;
  ddr = ./rk3588_ddr_lp4_2112MHz_lp5_2400MHz_uart9_115200_v1.16.bin;
in
stdenv.mkDerivation {
  pname = "rkbin";
  version = "0.1.0";
  buildCommand = ''
    mkdir $out
    cp ${bl31} $out/bl31.elf
    cp ${ddr} $out/ddr.bin
  '';
}
