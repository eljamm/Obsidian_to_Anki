{
  pkgs,
  ...
}:
{
  default = pkgs.mkShellNoCC {
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
