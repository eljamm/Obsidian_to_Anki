{
  pkgs,
  formatter,
  devAnki,
  devObsidian,
  ...
}:
let
  customPython = pkgs.python3.withPackages (
    ps: with ps; [
      pytest
    ]
  );
in
{
  default = pkgs.mkShellNoCC {
    inputsFrom = [ formatter.shell ];
    packages = with pkgs; [
      customPython
      devAnki.wrapper
      devObsidian.wrapper
      gitMinimal
      nodejs
      pinact
    ];
    shellHook = ''
      export PROJECT_ROOT="$(git rev-parse --show-toplevel)"
      export PYTHONPATH="$PYTHONPATH:${devAnki.pythonPath}"

      # better compat with IDEs
      ln -sf "${formatter.configFile}" "$PROJECT_ROOT/treefmt.toml"
    '';
  };
}
