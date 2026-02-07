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
    ];
  };
}
