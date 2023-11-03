{ lib, nixpkgs-unstable, darwin, home-manager, ... }:
{
  "Alis-MacBook-Pro-2" = darwin.lib.darwinSystem {
    system = "x86_64-darwin";
    pkgs = import nixpkgs-unstable {system = "x86_64-darwin"; overlays = [
      # HotFix: https://github.com/NixOS/nixpkgs/issues/263489
      # Results in latex build failure.
      (final: prev: {
  ghostscript = prev.ghostscript.overrideAttrs
    (old: {
      buildFlags = ["so" "LDFLAGS=-headerpad_max_install_names"];
    });
})
    ];};
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
