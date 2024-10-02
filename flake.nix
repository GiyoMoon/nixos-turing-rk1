{
  description = "NixOS configuration for the Turing RK1";
  inputs = {
    # Stable: github:NixOS/nixpkgs/nixos-24.05
    # Unstable: github:NixOS/nixpkgs/nixos-unstable
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # v6.12-rc1
    # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tag/?h=v6.12-rc1
    kernel = {
      url = "git+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git?rev=03dc72319cee7d0dfefee9ae7041b67732f6b8cd";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            # nixpkgs.ubootTuringRK1 includes proprietary binaries from Rockchip
            "ubootTuringRK1"
          ];
      };
    in
    {
      nixosModules = {
        turing-rk1 = { ... }@args: import ./modules/turing-rk1.nix (args // { inherit inputs pkgs; });
      };

      nixosConfigurations = {
        turing-rk1 = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit pkgs inputs;
          };

          modules = [
            ./modules/turing-rk1.nix
            ./modules/os.nix
          ];
        };
      };

      packages.${system}.uboot-turing-rk1 = import ./modules/uboot-sd-image.nix {
        stdenv = pkgs.stdenv;
        inherit pkgs;
      };
    };
}
