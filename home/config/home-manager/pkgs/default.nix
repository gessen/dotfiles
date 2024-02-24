{ pkgs }: {
  emacs-lsp-booster = pkgs.callPackage ./emacs-lsp-booster {};
  git-completion = pkgs.callPackage ./git-completion {};
  osc52 = pkgs.callPackage ./osc52 {};
  stormcloud-docker = pkgs.callPackage ./stormcloud-docker {};
  tig-completion = pkgs.callPackage ./tig-completion {};
}
