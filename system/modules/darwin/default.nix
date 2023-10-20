{ pkgs,mypackages, username ,... }: {
  # backwards compat; don't change
  system.stateVersion = 4;
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  services.nix-daemon.enable = true;
  users.users.${username}.home = "/Users/${username}/";

  # here go the darwin preferences and config items
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
  };

  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    systemPackages = mypackages pkgs;

  };

  # system.defaults = {
  #     finder.AppleShowAllExtensions = true;
  #     finder._FXShowPosixPathInTitle = true;
  #     dock.autohide = true;
  #     NSGlobalDomain.AppleShowAllExtensions = true;
  #     NSGlobalDomain.InitialKeyRepeat = 14;
  #     NSGlobalDomain.KeyRepeat = 1;
  # };

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    brews = [ "watch" ];
  };
}
