{ pkgs, ... }: {
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "22.11";
  # specify my home-manager configs
  home.packages = with pkgs; [
    texlive.combined.scheme-full
  ];

  programs.bat = {
    enable = true;
    config.theme = "TwoDark";
  };

  programs.zsh = {
    enable = true;
    # to avoid running compinit twice, complition already ran.
    enableCompletion = false;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "miloshadzic";
    };
    shellAliases = {
      nixswitch = "sudo darwin-rebuild switch --flake ~/Nix/system/.#";
      nixup = "pushd ~/Nix/system/.#; nix flake update; nixswitch; popd";
      jserver = "ssh aj@jamadi.me";
      codenix = "code ~/Nix/";
    };
  };

}
