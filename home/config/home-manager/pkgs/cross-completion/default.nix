{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

stdenv.mkDerivation rec {
  pname = "cross-completion";
  version = "1.0.0";

  phases = "installPhase";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    installShellCompletion --cmd cross \
      --zsh <(echo compdef cross=cargo) \
      --fish <(echo complete --command cross --wraps cargo)
  '';
}
