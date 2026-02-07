{
  lib,
  pkgs,
  inputs,

  devAnki,
  devObsidian,
  ...
}:

pkgs.testers.runNixOSTest {
  name = "Obsidian to Anki";

  nodes.machine =
    { ... }:
    {
      imports = [
        ./setup.nix
        ./virt.nix
      ];

      _module.args.inputs = inputs;

      environment.systemPackages = with pkgs; [
        anki
        devAnki.wrapper
        devObsidian.wrapper
        obsidian
        xdotool
      ];
    };

  testScript =
    { nodes, ... }:
    # python
    ''
      def click_position(x: int, y: int):
        machine.succeed(f"su - alice -c 'DISPLAY=:0 xdotool mousemove --sync {x} {y} click 1'")
        machine.sleep(1)

      start_all()

      machine.succeed()
    '';

  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock/3

  interactive.nodes.machine =
    { ... }:
    {
      environment.systemPackages = with pkgs; [
        neovim
        yazi
      ];
    };
}
