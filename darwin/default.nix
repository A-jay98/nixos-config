{ lib, nixpkgs-unstable, darwin, home-manager-unstable, ... }:
let
  home-manager = home-manager-unstable;
in
{
  "Alis-MacBook-Pro-2" = darwin.lib.darwinSystem {
    system = "x86_64-darwin";
    pkgs = import nixpkgs-unstable {
      system = "x86_64-darwin";
    };
    modules = [
      ./Alis-MacBook-Pro-2.nix
      home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      }
    ];
  };
}
