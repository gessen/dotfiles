if test -f $HOME/.nix-profile/etc/profile.d/nix.fish
    source $HOME/.nix-profile/etc/profile.d/nix.fish

    # Nix Help non-nix package to locate nix libraries
    set -gx PKG_CONFIG_PATH $HOME/.nix-profile/lib/pkgconfig
end
