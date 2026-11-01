{
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dewploy";
  version = "0.13.0";

  src = builtins.fetchGit {
    url = "git+ssh://git@github.com/gessen/dewploy.git";
    ref = "master";
    rev = "8cd6a0627ffcbd15ca02f2fbda9d0be6bb16b7d6";
  };
  cargoHash = "sha256-JoMRCTse9jiooN4nCRhQX72mVCYMtdmfi2TXf7ag1/8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dewploy \
      --fish $releaseDir/build/dewploy-*/out/dewploy.fish
    '';
}
