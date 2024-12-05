{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

stdenv.mkDerivation rec {
  pname = "cross-completion";
  version = "1.0.0";

  fishCompletion = writeText "cross.fish" ''
    complete --command cross --wraps cargo
  '';

  zshCompletion = writeText "_cross" ''
    compdef cross=cargo
  '';

  phases = "installPhase";

  installPhase = ''
    install -d $out/share/fish/vendor_completions.d
    install -d $out/share/zsh/site-functions
    install -m644 "${fishCompletion}" "$out/share/fish/vendor_completions.d/cross.fish"
    install -m644 "${zshCompletion}" "$out/share/zsh/site-functions/_cross"
  '';
}
