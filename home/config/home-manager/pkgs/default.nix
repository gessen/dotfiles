{ pkgs }:

with pkgs;

{
  cross-completion = callPackage ./cross-completion { };
  ew-buildenv = callPackage ./ew-buildenv { };
  osc52 = callPackage ./osc52 { };
}
