{ pkgs }:

with pkgs;

{
  cross-completion = callPackage ./cross-completion { };
  dewploy = callPackage ./dewploy { };
  ew-buildenv = callPackage ./ew-buildenv { };
  ew-devenv = callPackage ./ew-devenv { };
  gn = callPackage ./gn { };
  osc52 = callPackage ./osc52 { };
}
