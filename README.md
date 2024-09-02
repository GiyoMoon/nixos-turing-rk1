<div align="center"><img src="assets/nixos.svg" width=200 /></div>
<h1 align="center">NixOS Turing RK1</h1>

This flake builds a bootable `nixosSystem` for the [Turing RK1](https://turingpi.com/product/turing-rk1/). It uses u-boot from nixpkgs and the mainline kernel (`6.11.0-rc6`) from upstream. It includes a patch that enables fan curve control (Thanks [@soxrok2212](https://github.com/soxrok2212)).

## Building the image
As of now, you have to be on an `aarch64-linux` system to build the flake. Adding support for cross-compilation on `x86_64-linux` is planned.

```bash
nix build github:GiyoMoon/nixos-turing-rk1#nixosConfigurations.turing-rk1.config.system.build.sdImage
```

The created image can be found under `./result/sd-image/`.

Default credentials:
- username: `nixos`
- password: `turing`

## Flake input

You can use this flake as a hardware config in your flake:

```nix
  inputs = {
    turing-rk1 = {
      url = "github:GiyoMoon/nixos-turing-rk1";
    };
  };
```

Now you can include `turing-rk1.nixosModules.turing-rk1` in your modules for your system.

## Todo's
- [ ] Add the Mali G610 firmware required for the GPU
- [ ] Support cross-compilation on x86_64-linux

## Screenshots

![NixOS neofetch](./assets/neofetch.webp)

## References
- [ryan4yin/nixos-rk3588](https://github.com/ryan4yin/nixos-rk3588)
- [Joshua-Riek/ubuntu-rockchip](https://github.com/Joshua-Riek/ubuntu-rockchip)
- [@soxrok2212](https://github.com/soxrok2212) created the fan curve patch
