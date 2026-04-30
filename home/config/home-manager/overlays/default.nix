{
  system,
  emacs-overlay,
}:

final: prev:
let
  overlays = [
    (import ./emacs.nix { inherit system emacs-overlay; })
    (import ./emacs-lsp-booster.nix)
  ];
in
  prev.lib.composeManyExtensions overlays final prev
