{
  stdenv,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "ew-devenv";
  version = "1.0";
  src = lib.cleanSource ./.;

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -d "$out/opt/${pname}/"
    install -m644 Dockerfile "$out/opt/${pname}/"
    install -m755 build_alsi22.sh "$out/opt/${pname}/"
    install -m755 build_alsi24.sh "$out/opt/${pname}/"
  '';
}
