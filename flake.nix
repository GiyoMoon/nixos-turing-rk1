{
  description = "NixOS configuration for the Turing RK1";
  inputs = {
    # Stable: github:NixOS/nixpkgs/nixos-24.05
    # Unstable: github:NixOS/nixpkgs/nixos-unstable
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # v6.11-rc6
    # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tag/?h=v6.11-rc6
    kernel = {
      url = "git+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git?rev=8e7c1c539395e34648d859c20b0f9478eb5901cc";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # nixpkgs.ubootTuringRK1 includes proprietary binaries from Rockchip
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        turingrk1 = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs.inputs = inputs;
          specialArgs.pkgs = pkgs;

          modules = [
            ./modules/turingrk1.nix
            ./modules/os.nix
          ];
        };
      };
    };
}
