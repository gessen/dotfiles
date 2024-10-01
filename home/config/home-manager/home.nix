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
      aspell
      aspellDicts.en
      bat
      delta
      difftastic
      fasd
      fd
      fzf
      git
      helix
      htop
      jq
      lazygit
      librsync
      lsd
      pandoc
      ripgrep
      rsync
      sheldon
      tree
      unzip
      yazi
      zoxide
      zstd
      extraPackages.git-completion
      extraPackages.osc52
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
      ".config/emacs" = {
        source = "${dotfilesDir}/config/emacs";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
