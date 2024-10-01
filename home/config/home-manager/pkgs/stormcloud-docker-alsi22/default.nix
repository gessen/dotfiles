{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

stdenv.mkDerivation rec {
  pname = "stormcloud-docker-alsi22";
  version = "1.0.17";

  files = [
    ./Dockerfile
    ./build.sh
    ./Cross.toml
  ];
  src = builtins.filterSource (p: t: builtins.elem (/. + p) files) ./.;

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -d "$out/opt/${pname}"
    install -m644 Dockerfile "$out/opt/${pname}/"
    install -m755 build.sh "$out/opt/${pname}/"
    install -m644 Cross.toml "$out/opt/${pname}/"
  '';
}
