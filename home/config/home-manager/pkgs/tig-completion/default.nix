{ pkgs ? import <nixpkgs> {}}:

pkgs.stdenv.mkDerivation rec {
  pname = "tig-completion";
  version = "2.5.8";

  src = pkgs.fetchFromGitHub {
    owner = "jonas";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1yx63jfbaa5h0d3lfqlczs9l7j2rnhp5jpa8qcjn4z1n415ay2x5";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -D contrib/tig-completion.zsh  $out/share/zsh/site-functions/_tig
    install -D contrib/tig-completion.bash $out/share/zsh/site-functions/tig-completion.bash
  '';
}
