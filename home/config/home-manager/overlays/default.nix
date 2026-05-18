{
  system,
  emacs-overlay,
  pkgs-capnproto,
}:

final: prev:
let
  overlays = [
    (import ./capnproto.nix { inherit pkgs-capnproto; })
    (import ./emacs.nix { inherit system emacs-overlay; })
    (import ./emacs-lsp-booster.nix)
    (import ./protobuf.nix)
  ];
in
  prev.lib.composeManyExtensions overlays final prev
