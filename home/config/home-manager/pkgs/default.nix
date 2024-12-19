{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

{
  cross-completion = callPackage ./cross-completion { };
  dewploy = callPackage ./dewploy { };
  osc52 = callPackage ./osc52 { };
  stormcloud-docker = callPackage ./stormcloud-docker { };
  stormcloud-docker-alsi22 = callPackage ./stormcloud-docker-alsi22 { };
}
