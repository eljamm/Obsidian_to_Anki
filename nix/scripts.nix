{
  lib,
  pkgs,
  ...
}:
let
  ankiCustom = pkgs.anki.withAddons (
    with pkgs.ankiAddons;
    [
      anki-connect
    ]
  );
in
{
  anki = pkgs.writeShellScriptBin "anki" ''
    # NOTE: fusion is needed for Wayland
    # https://github.com/ankitects/anki/issues/1767
    env QT_STYLE_OVERRIDE="fusion" \
      ${lib.getExe ankiCustom} \
      -b "''${PROJECT_ROOT:-/tmp}"/.anki \
      "$@"
  '';
}
