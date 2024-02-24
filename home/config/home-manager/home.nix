{ config, pkgs, ... }:

let
  user = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
  dotfilesDir = "${homeDir}/.dotfiles/home";
  nixDir = "/nix/var/nix/profiles/per-user/${user}/profile/";
  extraPackages = pkgs.callPackage ./pkgs {};
in
{
  home = {
    username = "${user}";
    homeDirectory = "${homeDir}";
    packages = with pkgs; [
      aspell
      aspellDicts.en
      bat
      capnproto
      cargo-cross
      cmake
      delta
      difftastic
      emacs
      fasd
      fd
      fzf
      git
      gitui
      helix
      htop
      jq
      kitty
      librsync
      libtool
      lld
      lsd
      ninja
      openssh
      pandoc
      perl
      perl536Packages.PLS
      ranger
      ripgrep
      rsync
      rust-analyzer
      sccache
      sheldon
      tig
      tmux
      tree
      unzip
      yazi
      zellij
      zoxide
      zstd
      extraPackages.emacs-lsp-booster
      extraPackages.git-completion
      extraPackages.osc52
      extraPackages.stormcloud-docker
      extraPackages.tig-completion
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
      ".config/lsd" = {
        source = "${dotfilesDir}/config/lsd";
        recursive = true;
      };
      ".config/nix" = {
        source = "${dotfilesDir}/config/nix";
        recursive = true;
      };
      ".config/ranger" = {
        source = "${dotfilesDir}/config/ranger";
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
      ".config/tig" = {
        source = "${dotfilesDir}/config/tig";
        recursive = true;
      };
      ".config/tmux" = {
        source = "${dotfilesDir}/config/tmux";
        recursive = true;
      };
      ".config/wezterm" = {
        source = "${dotfilesDir}/config/wezterm";
        recursive = true;
      };
      ".config/yazi" = {
        source = "${dotfilesDir}/config/yazi";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
