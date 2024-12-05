{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;

rustPlatform.buildRustPackage rec {
  pname = "dewploy";
  version = "0.9.1";

  src = builtins.fetchGit {
    url = "git+ssh://git@github.com/gessen/dewploy.git";
    ref = "develop";
    rev = "791ff806d050353b36372efc3672cc7d46300fe4";
  };
  cargoHash = "sha256-AVpDP9YSVVmXgZHl3de92Nkh9x9oUR4Qx+hqv1dVzZk=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash --name dewploy.bash $releaseDir/build/dewploy-*/out/dewploy.bash
    installShellCompletion --zsh --name _dewploy $releaseDir/build/dewploy-*/out/_dewploy
    installShellCompletion --fish --name dewploy.fish $releaseDir/build/dewploy-*/out/dewploy.fish
  '';
}
