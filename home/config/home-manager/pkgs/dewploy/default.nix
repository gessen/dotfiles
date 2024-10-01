{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

rustPlatform.buildRustPackage rec {
  pname = "dewploy";
  version = "0.8.1";

  src = builtins.fetchGit {
    url = "git+ssh://git@github.com/gessen/dewploy.git";
    ref = "develop";
    rev = "349fdd02774c7a5ae825446481bc641263001593";
  };
  cargoHash = "sha256-v1OjThFb7b1WtQF90i+xjOzVkRX0kBep320mBUb3ZhI=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash --name dewploy.bash $releaseDir/build/dewploy-*/out/dewploy.bash
    installShellCompletion --zsh --name _dewploy $releaseDir/build/dewploy-*/out/_dewploy
  '';
}
