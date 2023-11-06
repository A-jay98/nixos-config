{ config, lib, pkgs, unstable, inputs, vars, ... }:

{
  imports = (import ../modules/shells);

  users.users.${vars.user} = {
    # System User
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  time.timeZone = "America/Edmonto"; # Time zone and Internationalisation
  i18n.defaultLocale = "en_US.UTF-8";


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  fonts.fonts = with pkgs; [
    # Fonts
    carlito # NixOS
    vegur # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    (nerdfonts.override {
      # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      # Environment Variables
    };
    systemPackages = with pkgs; [
      # System-Wide Packages
      # Terminal
      btop # Resource Manager
      coreutils # GNU Utilities
      git # Version Control
      vim # Text Editor
      nix-tree # Browse Nix Store
      ranger # File Manager
      tldr # Helper
      wget # Retriever

      # Other Packages Found @
      # - ./<host>/default.nix
      # - ../modules
    ] ++
    (with unstable; [
      # packages from unstable branch
    ]);
  };


  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixFlakes; # Enable Flakes
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings.experimental-features = "nix-command flakes";
  };
  nixpkgs.config.allowUnfree = true; # Allow Proprietary Software.

  system = {
    # NixOS Settings
    stateVersion = "23.05";
  };

  home-manager.users.${vars.user} = {
    # Home-Manager Settings
    home = {
      stateVersion = "23.05";
    };

    programs = {
      home-manager.enable = true;
    };
  };
}
