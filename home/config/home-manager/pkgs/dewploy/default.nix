{
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dewploy";
  version = "0.13.0";

  src = builtins.fetchGit {
    url = "git+ssh://git@github.com/gessen/dewploy.git";
    ref = "develop";
    rev = "a91324fa9ea3050c0212e2ad297fd8f6c43b23bb";
  };
  cargoHash = "sha256-JoMRCTse9jiooN4nCRhQX72mVCYMtdmfi2TXf7ag1/8=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dewploy \
      --fish $releaseDir/build/dewploy-*/out/dewploy.fish
    '';
}
