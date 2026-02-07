{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, ... }@inputs:
    let
      importFlake = system: (import ./. { inherit self inputs system; }).flake or { };

      inherit (inputs.flake-utils.lib)
        eachDefaultSystem
        ;
    in
    eachDefaultSystem importFlake;
}
