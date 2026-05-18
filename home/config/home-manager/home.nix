{
  pkgs,
  extraPkgs,
  username,
  ...
}:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      ast-grep
      atuin
      bat
      btop
      bun
      capnproto
      clang-tools
      cmake
      delta
      difftastic
      dtach
      dua
      emacs
      emacs-lsp-booster
      enchant
      enchant.dev
      eza
      fd
      fzf
      git
      git-lfs
      glib.dev
      gn
      hunspellDicts.en_US
      jq
      jujutsu
      less
      librsync
      libsysprof-capture
      libtool
      man-pages
      man-pages-posix
      mergiraf
      meson
      mise
      mold
      ninja
      nodejs
      nuspell
      pandoc
      patchelf
      pcre2.dev
      protobuf
      ripgrep
      rsync
      rust-analyzer
      sccache
      serie
      shellcheck
      shfmt
      tombi
      tree
      typescript
      unzip
      vivid
      yazi
      zoxide
      zstd

      extraPkgs.osc52
    ];

    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  programs.man = {
    enable = true;
    generateCaches = true;
  };
}
