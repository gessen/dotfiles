{
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dewploy";
  version = "0.11.0";

  src = builtins.fetchGit {
    url = "git+ssh://git@github.com/gessen/dewploy.git";
    ref = "develop";
    rev = "b1e1defbb888e587da19837f31f2c5c12ee7569c";
  };
  cargoHash = "sha256-RqtWG4jSKvwFl19v2FlGCkrPqKkj5HXGClNB5mUHW0Q=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dewploy \
      --fish $releaseDir/build/dewploy-*/out/dewploy.fish
    '';
}
