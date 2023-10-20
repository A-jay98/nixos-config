{
  description = "my minimal flake";


  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

  };


  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: 
  let 
    username="jamadi";
    hostname="Alis-MacBook-Pro-2";
  in {
    darwinConfigurations.${hostname} = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      pkgs = import nixpkgs { system = "x86_64-darwin"; };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username}.imports = [ ./modules/home-manager ];
          };
        }
      ];
      specialArgs = {inherit username hostname; mypackages=import ./packages.nix; };
    };
  };
}