{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

stdenv.mkDerivation rec {
  pname = "stormcloud-docker";
  version = "1.0";
  src = lib.cleanSource ./.;

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -d "$out/opt/${pname}/alsi11/"
    install -d "$out/opt/${pname}/alsi22/"
    install -m644 alsi11/Dockerfile "$out/opt/${pname}/alsi11/"
    install -m755 alsi11/build.sh "$out/opt/${pname}/alsi11/"
    install -m644 alsi11/Cross.toml "$out/opt/${pname}/alsi11/"
    install -m644 alsi22/Dockerfile "$out/opt/${pname}/alsi22/"
    install -m755 alsi22/build.sh "$out/opt/${pname}/alsi22/"
    install -m644 alsi22/Cross.toml "$out/opt/${pname}/alsi22/"
  '';
}
