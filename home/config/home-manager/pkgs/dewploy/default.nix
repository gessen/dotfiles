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
  cargoHash = "sha256-cjr7VHtx6yFmHsr6/QqHeqj4NwuPEQQmODPBfB+hBO4=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dewploy \
      --bash $releaseDir/build/dewploy-*/out/dewploy.bash \
      --zsh $releaseDir/build/dewploy-*/out/_dewploy \
      --fish $releaseDir/build/dewploy-*/out/dewploy.fish
    '';
}
