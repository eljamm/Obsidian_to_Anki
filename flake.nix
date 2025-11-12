{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:fricklerhandwerk/git-hooks";
    git-hooks.flake = false;
  };

  outputs =
    { self, ... }@inputs:
    let
      default = import ./. { inherit self inputs; };
      mkSystemFlake = system: (import ./. { inherit self inputs system; }).flake.perSystem;
    in
    (inputs.flake-utils.lib.eachDefaultSystem mkSystemFlake) // default.flake.system-agnostic;
}
