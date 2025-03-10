{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

{
  cross-completion = callPackage ./cross-completion { };
  dewploy = callPackage ./dewploy { };
  osc52 = callPackage ./osc52 { };
  stormcloud-docker = callPackage ./stormcloud-docker { };
  stormcloud-docker-v2 = callPackage ./stormcloud-docker-v2 { };
}
