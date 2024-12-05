{ config, pkgs, ... }:

let
  user = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";
  dotfilesDir = "${homeDir}/.dotfiles/home";
  extraPackages = pkgs.callPackage ./pkgs { };
in
{
  home = {
    username = "${user}";
    homeDirectory = "${homeDir}";
    packages = with pkgs; [
      atuin
      bat
      btop
      delta
      dua
      fd
      fzf
      helix
      librsync
      lsd
      ripgrep
      rsync
      serie
      sheldon
      tree
      unzip
      yazi
      zoxide
      zstd
      extraPackages.git-completion
      extraPackages.osc52
    ];

    stateVersion = "23.11";

    file = {
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
      ".config/emacs" = {
        source = "${dotfilesDir}/config/emacs";
        recursive = true;
      };
      ".config/fish" = {
        source = "${dotfilesDir}/config/fish";
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
      ".config/ripgrep" = {
        source = "${dotfilesDir}/config/ripgrep";
        recursive = true;
      };
      ".config/sheldon" = {
        source = "${dotfilesDir}/config/sheldon";
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
      ".ssh" = {
        source = "${dotfilesDir}/ssh";
        recursive = true;
      };
      ".zprofile".source = "${dotfilesDir}/zprofile";
      ".zshrc".source = "${dotfilesDir}/zshrc";
    };
  };

  programs.home-manager.enable = true;
}
