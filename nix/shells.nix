{
  pkgs,
  formatter,
  scripts,
  ...
}:
{
  default = pkgs.mkShellNoCC {
    inputsFrom = [ formatter.shell ];
    packages = with pkgs; [
      (python3.withPackages (
        ps: with ps; [
          pytest
          anki
        ]
      ))
      gitMinimal
      nodejs
      pinact
      scripts.anki
    ];
    shellHook = ''
      export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

      # better compat with IDEs
      ln -sf "${formatter.configFile}" "$PROJECT_ROOT/treefmt.toml"
    '';
  };
}
