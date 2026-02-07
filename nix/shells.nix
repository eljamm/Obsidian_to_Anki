{
  pkgs,
  formatter,
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
      nodejs
      pinact
      gitMinimal
    ];
    shellHook = ''
      PROJECT_ROOT="$(git rev-parse --show-toplevel)"

      # better compat with IDEs
      ln -sf "${formatter.configFile}" "$PROJECT_ROOT/treefmt.toml"
    '';
  };
}
