{ pkgs }:

with pkgs;

{
  cross-completion = callPackage ./cross-completion { };
  ew-buildenv = callPackage ./ew-buildenv { };
  ew-devenv = callPackage ./ew-devenv { };
  osc52 = callPackage ./osc52 { };
}
