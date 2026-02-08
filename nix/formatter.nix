{
  lib,
  pkgs,
  inputs,
  ...
}:
lib.makeExtensible (self: {
  treefmt = import inputs.treefmt-nix;

  config = {
    projectRootFile = ".git/config";
    programs.nixfmt.enable = true;
    programs.actionlint.enable = true;
    programs.zizmor.enable = true;
    programs.yamlfmt.enable = true;
    programs.prettier.enable = true;
    programs.prettier.settings.editorconfig = true;
    programs.beautysh = {
      enable = true;
      indent_size = 4;
    };
    # TODO:
    # programs.ruff-check.enable = true;
    programs.ruff-format.enable = true;
  };

  # evaluated config
  eval = self.treefmt.evalModule pkgs self.config;
  configFile = self.eval.config.build.configFile;

  # treefmt package
  package = self.eval.config.build.wrapper;

  # development shell that contains all formatters
  shell = self.eval.config.build.devShell;
})
