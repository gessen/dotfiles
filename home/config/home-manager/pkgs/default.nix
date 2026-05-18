{ pkgs }:

with pkgs;

{
  cross-completion = callPackage ./cross-completion { };
  ew-buildenv = callPackage ./ew-buildenv { };
  gn = callPackage ./gn { };
  osc52 = callPackage ./osc52 { };
}
