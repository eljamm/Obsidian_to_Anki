{
  self ? import ./nix/utils/import-flake.nix { src = ./.; },
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
  scope = lib.makeScope pkgs.newScope (
    self': with self'; {
      inherit
        lib
        pkgs
        self
        system
        inputs
        ;

      # Custom library. Contains helper functions, builders, ...
      devLib = callPackage ./nix/lib.nix { };

      formatter = callPackage ./nix/formatter.nix { };
      # devPkgs = lib.filterAttrs (n: v: lib.isDerivation v) (callPackage ./nix/packages.nix { });
      devPkgs = { };
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [
          self'.formatter.package
          nodejs
          anki
          (python3.withPackages (
            ps: with ps; [
              pytest
            ]
          ))
        ];
      };

      overlays.default = final: prev: devPkgs;

      flake.system-agnostic = {
        inherit overlays;
      };
      flake.perSystem = {
        devShells = devShells;
        formatter = format.formatter;
        packages = devPkgs;
        checks = lib.filterAttrs (_: v: !v.meta.broken or false) flake.perSystem.packages;
        legacyPackages = {
          lib = devLib;
          packages = devPkgs;
        };
      };
    }
  );
in
scope // scope.devPkgs
