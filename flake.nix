{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # Stable Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Unstable Nix Packages

    home-manager-unstable = {
      # User Environment Manager
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      # User Environment Manager
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      # MacOS Package Management
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };


    # VScode server
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs_ltex-ls.url = "github:NixOS/nixpkgs/d8c8f21bdf087cf2c1a259d8925bfd3e85c3339c";

    #authentik used by Athena 
    authentik-nix = {
    url = "github:nix-community/authentik-nix";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, darwin, vscode-server, ... }: {
    nixosConfigurations = (
      # NixOS Configurations
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager vscode-server; # Inherit inputs
      }
    );

    darwinConfigurations = (
      # Darwin Configurations
      import ./darwin {
        inherit inputs nixpkgs nixpkgs-unstable home-manager-unstable darwin;
        inherit (nixpkgs) lib;
      }
    );

    homeConfigurations = (
      # Nix Configurations
      import ./nix {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager;
      }
    );
  };
}
