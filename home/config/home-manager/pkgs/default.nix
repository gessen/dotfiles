{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

{
  dewploy = callPackage ./dewploy { };
  git-completion = callPackage ./git-completion { };
  osc52 = callPackage ./osc52 { };
  stormcloud-docker = callPackage ./stormcloud-docker { };
  stormcloud-docker-alsi22 = callPackage ./stormcloud-docker-alsi22 { };
}
