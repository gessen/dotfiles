{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

stdenv.mkDerivation rec {
  pname = "osc52";
  version = "1.0.0";

  scriptFile = writeShellScript "${pname}" ''
    printf "\033]52;c;$(base64 | tr -d '\r\n')\a"
  '';

  phases = "installPhase";

  installPhase = ''
    install -d "$out/bin/"
    install "${scriptFile}" "$out/bin/${pname}"
  '';
}
