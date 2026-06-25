{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url  = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-capnproto.url = "github:NixOS/nixpkgs/21808d22b1cda1898b71cf1a1beb524a97add2c4";
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, nixpkgs-capnproto, ... }:
    let
      system = "x86_64-linux";
      username = "jswierk";
      pkgs-capnproto = import nixpkgs-capnproto { inherit system; };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import ./overlays {
            inherit system emacs-overlay pkgs-capnproto;
          })
        ];
      };
      extraPkgs = pkgs.callPackage ./pkgs { };
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          inherit extraPkgs username;
        };
      };
    };
}
