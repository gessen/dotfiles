{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

{
  osc52 = callPackage ./osc52 { };
}
