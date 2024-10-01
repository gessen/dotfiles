{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

stdenv.mkDerivation rec {
  pname = "git-completion";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "felipec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E7CPxo5MJejUlzD6h5wWDGGp/XPx1/w4bbOuywVxvJU=";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -d $out/share/zsh/site-functions
    install -m644 git-completion.zsh  $out/share/zsh/site-functions/_git
    install -m644 git-completion.bash $out/share/zsh/site-functions/git-completion.bash
  '';
}
