{
  lib,
  config,
  ...
}:
{
  virtualisation = {
    memorySize = 4096;
    diskSize = 4096;
    cores = 4;
    graphics = lib.mkIf (!config.services.xserver.enable) false;

    qemu.options = [
      "-cpu host"
      "-enable-kvm"
    ];

    # allows Nix commands to re-use and write to the host's store
    mountHostNixStore = true;
    writableStoreUseTmpfs = false;
  };
}
