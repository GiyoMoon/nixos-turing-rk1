{ lib, ... }:
let
  username = "nixos";
  # openssl passwd -6
  # default password: turing
  hashedPassword = "$6$C5hAzJ7DTUk9aJ2V$TYcj76ARJhnIRzGlpkYaHfaMhmTs0ce3mx884Jnnh/g65EzceLi2JXENUTz0R5VGGNY/wmUFhXqUcNGh6MTRw1";
in
{
  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "@wheel" ];
  };

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  documentation = {
    man.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PasswordAuthentication = lib.mkDefault true;
    };
    openFirewall = lib.mkDefault true;
  };

  networking.hostName = "turing-rk1";
  users.users."${username}" = {
    inherit hashedPassword;
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [ "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05";
}
