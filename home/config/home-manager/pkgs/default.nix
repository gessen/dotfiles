{ pkgs }:

with pkgs;

{
  gn = callPackage ./gn { };
  osc52 = callPackage ./osc52 { };
}
