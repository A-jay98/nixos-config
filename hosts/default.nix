{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, ... }:

let
  system = "x86_64-linux"; # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow Proprietary Software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{

  jnix = lib.nixosSystem {
    # Server Profile
    inherit system;
    specialArgs = {
      # Pass Flake Variable
      inherit inputs system unstable hyprland;
      vars = {
        hostName = "jnix";
        user = "aj";
      };
    };
    modules = [
      # Modules Used
      ./jnix
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        # Home-Manager Module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };



}
