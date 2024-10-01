{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

{
  git-completion = callPackage ./git-completion { };
  osc52 = callPackage ./osc52 { };
}
