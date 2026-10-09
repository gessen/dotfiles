{
  system,
  emacs-overlay,
}:

final: prev: {
  emacs = emacs-overlay.packages.${system}.emacs-git;
}
