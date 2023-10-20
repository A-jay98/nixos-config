{ pkgs, ... }: {
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "22.11";
  # specify my home-manager configs
  #   home.packages = with pkgs; [
  #     # ripgrep
  #     # fd
  #     # curl
  #     # less
  #     # pwnvim.packages."aarch64-darwin".default
  #   ];
  #   home.sessionVariables = {
  #     PAGER = "less";
  #     CLICLOLOR = 1;
  #     EDITOR = "nvim";
  #   };
  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  programs.zsh = {
    enable = true;
    # to avoid running compinit twice, complition already ran.
    enableCompletion = false;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "miloshadzic";
    };
    shellAliases = {
      nixswitch = "darwin-rebuild switch --flake ~/Nix/system/.#";
      nixup = "pushd ~/Nix/system/.#; nix flake update; nixswitch; popd";
      jserver = "ssh aj@jamadi.me";
    };
  };

}
