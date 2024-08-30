{
  stdenv,
  linuxManualConfig,
  inputs,
  flex,
  bison,
  perl,
  ...
}:
let
  src = inputs.kernel;
in
linuxManualConfig {
  inherit src;

  version = "6.11.0-rc5";

  configfile = stdenv.mkDerivation {
    inherit src;
    name = "kernel-config";

    nativeBuildInputs = [
      flex
      bison
      perl
    ];

    buildPhase = ''
      make defconfig
      scripts/config --module CONFIG_CRYPTO_USER_API_HASH

      # Enable nf_tables, required for the firewall and docker
      scripts/config --module CONFIG_NF_TABLES
      scripts/config --enable CONFIG_NF_TABLES_INET
      scripts/config --module CONFIG_NFT_NAT
      scripts/config --module CONFIG_NFT_CT
      scripts/config --enable CONFIG_NF_TABLES_NETDEV
      scripts/config --module CONFIG_NFT_NUMGEN
      scripts/config --module CONFIG_NETFILTER_NETLINK_HOOK
      scripts/config --module CONFIG_NFT_NUMGEN
      scripts/config --module CONFIG_NFT_CT
      scripts/config --module CONFIG_NFT_CONNLIMIT
      scripts/config --module CONFIG_NFT_LOG
      scripts/config --module CONFIG_NFT_LIMIT
      scripts/config --module CONFIG_NFT_MASQ
      scripts/config --module CONFIG_NFT_REDIR
      scripts/config --module CONFIG_NFT_NAT
      scripts/config --module CONFIG_NFT_TUNNEL
      scripts/config --module CONFIG_NFT_QUOTA
      scripts/config --module CONFIG_NFT_REJECT
      scripts/config --module CONFIG_NFT_REJECT_INET
      scripts/config --module CONFIG_NFT_COMPAT
      scripts/config --module CONFIG_NFT_HASH
      scripts/config --module CONFIG_NFT_SOCKET
      scripts/config --module CONFIG_NFT_OSF
      scripts/config --module CONFIG_NFT_TPROXY
      scripts/config --module CONFIG_NFT_SYNPROXY
      scripts/config --module CONFIG_NF_DUP_NETDEV
      scripts/config --module CONFIG_NFT_DUP_NETDEV
      scripts/config --module CONFIG_NFT_FWD_NETDEV
      scripts/config --module CONFIG_NFT_REJECT_NETDEV
      scripts/config --module CONFIG_NETFILTER_XTABLES
      scripts/config --module CONFIG_NETFILTER_XT_MATCH_PKTTYPE

      # Enable RAID 1
      scripts/config --module CONFIG_MD_RAID1

      make oldconfig
    '';

    installPhase = ''
      cp .config $out
    '';
  };
  allowImportFromDerivation = true;
  kernelPatches = [
    {
      name = "rk3588-turing-rk1-fan-curve";
      patch = ./patches/01_rk3588-turing-rk1-fan-curve.patch;
    }
  ];
}
