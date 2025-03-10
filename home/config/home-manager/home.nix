{ config, pkgs, ... }:

let
  user = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
  dotfilesDir = "${homeDir}/.dotfiles/home";
  extraPackages = pkgs.callPackage ./pkgs { };
in
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  home = {
    username = "${user}";
    homeDirectory = "${homeDir}";
    packages = with pkgs; [
      aspell
      aspellDicts.en
      atuin
      bat
      btop
      capnproto
      cargo-cross
      clang-tools
      cmake
      delta
      difftastic
      dtach
      dua
      emacs-git
      emacs-lsp-booster
      eza
      fd
      fzf
      git
      gitui
      helix
      jq
      jujutsu
      kitty
      less
      librsync
      libtool
      meson
      mise
      mold
      ninja
      nodejs
      pandoc
      ripgrep
      rsync
      rust-analyzer
      serie
      sccache
      tree
      typescript
      unzip
      yazi
      zoxide
      zstd
      extraPackages.cross-completion
      extraPackages.dewploy
      extraPackages.osc52
      extraPackages.stormcloud-docker
    ];

    stateVersion = "24.11";

    file = {
      ".config/aspell" = {
        source = "${dotfilesDir}/config/aspell";
        recursive = true;
      };
      ".config/atuin" = {
        source = "${dotfilesDir}/config/atuin";
        recursive = true;
      };
      ".config/bat" = {
        source = "${dotfilesDir}/config/bat";
        recursive = true;
      };
      ".config/btop" = {
        source = "${dotfilesDir}/config/btop";
        recursive = true;
      };
      ".config/ccache" = {
        source = "${dotfilesDir}/config/ccache";
        recursive = true;
      };
      ".config/clangd" = {
        source = "${dotfilesDir}/config/clangd";
        recursive = true;
      };
      ".config/emacs" = {
        source = "${dotfilesDir}/config/emacs";
        recursive = true;
      };
      ".config/fish" = {
        source = "${dotfilesDir}/config/fish";
        recursive = true;
      };
      ".config/gdb" = {
        source = "${dotfilesDir}/config/gdb";
        recursive = true;
      };
      ".config/gdb-dashboard" = {
        source = "${dotfilesDir}/config/gdb-dashboard";
        recursive = true;
      };
      ".config/git" = {
        source = "${dotfilesDir}/config/git";
        recursive = true;
      };
      ".config/helix" = {
        source = "${dotfilesDir}/config/helix";
        recursive = true;
      };
      ".config/jj" = {
        source = "${dotfilesDir}/config/jj";
        recursive = true;
      };
      ".config/kitty" = {
        source = "${dotfilesDir}/config/kitty";
        recursive = true;
      };
      ".config/lsd" = {
        source = "${dotfilesDir}/config/lsd";
        recursive = true;
      };
      ".config/mise" = {
        source = "${dotfilesDir}/config/mise";
        recursive = true;
      };
      ".config/nix" = {
        source = "${dotfilesDir}/config/nix";
        recursive = true;
      };
      ".config/ra-multiplex" = {
        source = "${dotfilesDir}/config/ra-multiplex";
        recursive = true;
      };
      ".config/ripgrep" = {
        source = "${dotfilesDir}/config/ripgrep";
        recursive = true;
      };
      ".config/sccache" = {
        source = "${dotfilesDir}/config/sccache";
        recursive = true;
      };
      ".config/yazi" = {
        source = "${dotfilesDir}/config/yazi";
        recursive = true;
      };
      ".config/zed" = {
        source = "${dotfilesDir}/config/zed";
        recursive = true;
      };
      ".local/share/cargo/config.toml" = {
        source = "${dotfilesDir}/local/share/cargo/config.toml";
      };
      ".ssh" = {
        source = "${dotfilesDir}/ssh";
        recursive = true;
      };
    };
  };

  systemd.user.services.ra-mux = {
    Unit = {
      Description = "Rust Analyzer multiplex server";
    };
    Service = {
      Type = "simple";
      ExecStart= "/home/jswierk/.local/share/cargo/bin/ra-multiplex server";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.home-manager.enable = true;
}
