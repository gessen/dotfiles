final: prev: {
  emacs-lsp-booster = prev.emacs-lsp-booster.overrideAttrs (_: {
    doCheck = false;
  });
}
