{
  stdenv,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "cross-completion";
  version = "1.0.0";

  phases = "installPhase";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    installShellCompletion --cmd cross \
      --fish <(echo complete -c cross -w cargo)
  '';
}
