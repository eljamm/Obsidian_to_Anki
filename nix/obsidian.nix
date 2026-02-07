{
  pkgs,
  ...
}:
{
  wrapper = pkgs.writeShellApplication {
    name = "obsidian-service";

    runtimeInputs = with pkgs; [
      curl
      obsidian
    ];

    text = ''
      export OBSIDIAN_VERSION="${pkgs.obsidian.version}"
      export CUSTOM_PORT="''${CUSTOM_PORT:-9090}"
      export CUSTOM_HTTPS_PORT="''${CUSTOM_HTTPS_PORT:-8443}"
      export CUSTOM_USER="''${CUSTOM_USER:-""}"
      export PASSWORD="''${PASSWORD:-""}"
      export SUBFOLDER="''${SUBFOLDER:-""}"
      export TITLE="''${TITLE:-"Obsidian v$OBSIDIAN_VERSION"}"
      export FM_HOME="''${PROJECT_ROOT:-"/tmp"}/vaults"

      echo "Starting $TITLE on port $CUSTOM_PORT..."

      obsidian \
        --no-sandbox \
        --no-xshm \
        --disable-dev-shm-usage \
        --disable-gpu \
        --disable-software-rasterizer \
        "$@"
    '';
  };
}
