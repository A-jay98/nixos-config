{
  description = "Nix, NixOS and Nix Darwin System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # Stable Nix Packages (Default)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Unstable Nix Packages

    home-manager = {
      # User Environment Manager
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    darwin = {
      # MacOS Package Management
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }: {
    nixosConfigurations = (
      # NixOS Configurations
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager; # Inherit inputs
      }
    );

    darwinConfigurations = (
      # Darwin Configurations
      import ./darwin {
        inherit inputs nixpkgs nixpkgs-unstable home-manager darwin;
        inherit (nixpkgs) lib;
      }
    );

      homeConfigurations = (
        # Nix Configurations
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nixgl vars;
        }
      );
  };
}
