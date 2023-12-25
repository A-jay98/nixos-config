{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, vscode-server, ... }:

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
      inherit inputs system unstable;
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

      vscode-server.nixosModules.default
      {
        services.vscode-server.enable = true;
      }
    ];
  };


  heracles = lib.nixosSystem {
    # Server Profile
    inherit system;
    specialArgs = {
      # Pass Flake Variable
      inherit inputs system unstable;
      vars = {
        hostName = "heracles";
        user = "aj";
      };
    };
    modules = [
      # Modules Used
      ./heracles
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        # Home-Manager Module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };


  athena = lib.nixosSystem {
    # Server Profile
    inherit system;
    specialArgs = {
      # Pass Flake Variable
      inherit inputs system unstable;
      vars = {
        hostName = "athena";
        user = "aj";
      };
    };
    modules = [
      # Modules Used
      ./athena
    ];
  };



}
