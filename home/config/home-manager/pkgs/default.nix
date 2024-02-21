{ pkgs }: {
  git-completion = pkgs.callPackage ./git-completion {};
  osc52 = pkgs.callPackage ./osc52 {};
  tig-completion = pkgs.callPackage ./tig-completion {};
}
