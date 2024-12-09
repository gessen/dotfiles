{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

rustPlatform.buildRustPackage rec {
  pname = "dewploy";
  version = "0.10.0";

  src = builtins.fetchGit {
    url = "git+ssh://git@github.com/gessen/dewploy.git";
    ref = "develop";
    rev = "1044b6f01afc3fe0a1b097638cb70ccd93c19067";
  };
  cargoHash = "sha256-hpW1RbrE/DVwzEXR+lcy7914fllZEut3KV/RQAKDrD8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash --name dewploy.bash $releaseDir/build/dewploy-*/out/dewploy.bash
    installShellCompletion --zsh --name _dewploy $releaseDir/build/dewploy-*/out/_dewploy
    installShellCompletion --fish --name dewploy.fish $releaseDir/build/dewploy-*/out/dewploy.fish
  '';
}
