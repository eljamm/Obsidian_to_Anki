{
  lib,
  pkgs,
  inputs,
  ...
}:
lib.makeExtensible (self: {
  treefmt = import inputs.treefmt-nix;

  config = {
    projectRootFile = "default.nix";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    programs.zizmor.enable = true;
    programs.yamlfmt.enable = true;
  };

  # evaluated config
  eval = self.treefmt.evalModule pkgs self.config;

  # treefmt package
  package = self.eval.config.build.wrapper;

  # development shell that contains all formatters
  shell = self.eval.config.build.devShell;
})
