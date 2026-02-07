{
  lib,
  inputs,
  ...
}:
{
  imports = [
    # enable graphical session + users (alice, bob)
    "${inputs.nixpkgs}/nixos/tests/common/x11.nix"
    "${inputs.nixpkgs}/nixos/tests/common/user-account.nix"
  ];

  # enable Nix inside the VM
  environment.variables.NIX_PATH = lib.mkForce "nixpkgs=${inputs.nixpkgs}";

  # enable flakes
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  security.sudo.wheelNeedsPassword = false;
  services.getty.autologinUser = lib.mkDefault "alice";
  services.displayManager.autoLogin.user = lib.mkDefault "alice";
}
