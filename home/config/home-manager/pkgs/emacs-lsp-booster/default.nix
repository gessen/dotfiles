{ pkgs ? import <nixpkgs> {}}:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "emacs-lsp-booster";
  version = "0.1.1";
  cargoSha256 = "sha256-quqhAMKsZorYKFByy2bojGgYR2Ps959Rg/TP8SnwbqM=";

  src = pkgs.fetchgit {
    url = "https://github.com/blahgeek/emacs-lsp-booster";
    rev = "b98b873226b587bd1689b2073ea114d8eaa3676f";
    sha256 = "uJ4EKBLZ95Ig2dpocB/vduYXj3eKg20tXKa1KDl2DAU=";
  };

  doCheck = false;
}
