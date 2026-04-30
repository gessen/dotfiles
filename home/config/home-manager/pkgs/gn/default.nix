{
  stdenv,
  fetchgit,
  writeText,
  ninja,
  python3,
  ...
}:

let
  rev = "0c25d1bbde6ef17e1e6d3938011f56a00c02e457";
  revShort = builtins.substring 0 7 rev;
  revNum = "2235";
  lastCommitPosition = writeText "last_commit_position.h" ''
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION_NUM ${revNum}
    #define LAST_COMMIT_POSITION "${revNum} (${revShort})"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
  '';
in
stdenv.mkDerivation rec {
  pname = "gn";
  version = "2025-05-15";

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev;
    sha256 = "sha256-L397H98lZOVafVmgamlAH6bcByj/kV2wyLdi722fhmI=";
  };

  nativeBuildInputs = [ ninja python3 ];

  env.CXXFLAGS = "-Wno-format-security";

  configurePhase = ''
    python build/gen.py --no-last-commit-position
    ln -s ${lastCommitPosition} out/last_commit_position.h
  '';

  buildPhase = ''
    ninja -j $NIX_BUILD_CORES -C out
  '';

  installPhase = ''
    install -vD out/gn "$out/bin/gn"
  '';
}
