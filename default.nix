{
  flake-inputs ? import (fetchTarball {
    url = "https://github.com/fricklerhandwerk/flake-inputs/tarball/4.1.0";
    sha256 = "1j57avx2mqjnhrsgq3xl7ih8v7bdhz1kj3min6364f486ys048bm";
  }),
  self ? flake-inputs.import-flake { src = ./.; },
  inputs ? self.inputs,
  system ? builtins.currentSystem,
  pkgs ? import inputs.nixpkgs {
    config = { };
    overlays = [ ];
    inherit system;
  },
  lib ? import "${inputs.nixpkgs}/lib",
}:
let
  default = lib.makeScope pkgs.newScope (def: {
    inherit
      lib
      pkgs
      self
      system
      inputs
      default # recurse scope
      ;

    devLib = def.callPackage ./nix/lib.nix { };
    formatter = def.callPackage ./nix/formatter.nix { };
    shells = def.callPackage ./nix/shells.nix { };
    scripts = def.callPackage ./nix/scripts.nix { };

    flake = def.callPackage ./nix/flake.nix { };
  });
in
default
