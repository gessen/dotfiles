{ pkgs ? import <nixpkgs> {}}:

pkgs.stdenv.mkDerivation rec {
  pname = "git-completion";
  version = "2.0";

  src = pkgs.fetchFromGitHub {
    owner = "felipec";
    repo = pname;
    rev = "v${version}";
    sha256 = "KfMBngxPbMSdD2tc+RIFUEku5ulWeyK9pLlKzweYjZE=";
  };

  phases = "unpackPhase installPhase";

  installPhase = ''
    install -d $out/share/zsh/site-functions
    install -m644 git-completion.zsh  $out/share/zsh/site-functions/_git
    install -m644 git-completion.bash $out/share/zsh/site-functions/git-completion.bash
  '';
}
