{
  lib,
  pkgs,
  ...
}:
lib.makeExtensible (self: {
  addons = with pkgs.ankiAddons; [
    anki-connect
  ];

  package = pkgs.anki.withAddons self.addons;

  wrapper = pkgs.writeShellApplication {
    name = "anki";
    runtimeInputs = [ self.package ];
    text = ''
      # NOTE: fusion is needed for Wayland
      # https://github.com/ankitects/anki/issues/1767
      env QT_STYLE_OVERRIDE="fusion" anki \
        -b "''${PROJECT_ROOT:-/tmp}"/.anki \
        "$@"
    '';
  };

  pythonPath = "${pkgs.anki.lib}/${pkgs.python3.sitePackages}";
})
