{
  description = "NixOS configuration for the Turing RK1";
  inputs = {
    # Stable: github:NixOS/nixpkgs/nixos-24.05
    # Unstable: github:NixOS/nixpkgs/nixos-unstable
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # v6.11-rc5
    # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tag/?h=v6.11-rc5
    kernel = {
      url = "git+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git?rev=042a071fcf19ce0b699ad7caaa4726915f740dd6";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; };
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
