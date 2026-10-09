{
  system,
  emacs-overlay,
}:

final: prev:
let
  overlays = [
    (import ./emacs.nix { inherit system emacs-overlay; })
  ];
in
  prev.lib.composeManyExtensions overlays final prev
