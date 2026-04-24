{
  stdenv,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "ew-buildenv";
  version = "1.0";
  src = lib.cleanSource ./.;

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -d "$out/opt/${pname}/alsi22/"
    install -d "$out/opt/${pname}/alsi24/"
    install -m644 alsi22/Dockerfile "$out/opt/${pname}/alsi22/"
    install -m644 alsi24/Dockerfile "$out/opt/${pname}/alsi24/"
    install -m755 alsi22/build.sh "$out/opt/${pname}/alsi22/"
    install -m755 alsi24/build.sh "$out/opt/${pname}/alsi24/"
    install -m644 alsi22/Cross.toml "$out/opt/${pname}/alsi22/"
    install -m644 alsi24/Cross.toml "$out/opt/${pname}/alsi24/"
  '';
}
