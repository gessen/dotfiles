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
      bat
      capnproto
      cargo-cross
      clang-tools
      cmake
      delta
      difftastic
      emacs-git-nox
      emacs-lsp-booster
      fasd
      fd
      fzf
      git
      helix
      htop
      jq
      lazygit
      less
      librsync
      libtool
      lld
      lsd
      meson
      ninja
      nodejs
      pandoc
      ripgrep
      rsync
      rust-analyzer
      sccache
      sheldon
      tmux
      tree
      typescript
      unzip
      yazi
      zellij
      zoxide
      zstd
      extraPackages.dewploy
      extraPackages.git-completion
      extraPackages.osc52
      extraPackages.stormcloud-docker
      extraPackages.stormcloud-docker-alsi22
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";

    file = {
      ".config/aspell" = {
        source = "${dotfilesDir}/config/aspell";
        recursive = true;
      };
      ".config/bat" = {
        source = "${dotfilesDir}/config/bat";
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
      ".config/htop" = {
        source = "${dotfilesDir}/config/htop";
        recursive = true;
      };
      ".config/kitty" = {
        source = "${dotfilesDir}/config/kitty";
        recursive = true;
      };
      ".config/lazygit" = {
        source = "${dotfilesDir}/config/lazygit";
        recursive = true;
      };
      ".config/lsd" = {
        source = "${dotfilesDir}/config/lsd";
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
      ".config/sheldon" = {
        source = "${dotfilesDir}/config/sheldon";
        recursive = true;
      };
      ".config/tmux" = {
        source = "${dotfilesDir}/config/tmux";
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
      ".config/zellij" = {
        source = "${dotfilesDir}/config/zellij";
        recursive = true;
      };
      ".local/share/cargo/config.toml" = {
        source = "${dotfilesDir}/local/share/cargo/config.toml";
      };
      ".ssh" = {
        source = "${dotfilesDir}/ssh";
        recursive = true;
      };
      ".zprofile".source = "${dotfilesDir}/zprofile";
      ".zshrc".source = "${dotfilesDir}/zshrc";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
