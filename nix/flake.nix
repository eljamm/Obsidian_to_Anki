{
  lib,
  default,
  ...
}:
lib.makeExtensible (self: {
  formatter = default.formatter.package;
  devShells = default.shells;

  legacyPackages.lib = default.devLib;
})
