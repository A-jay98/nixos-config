{ pkgs, ... }:
let
  username = "jamadi";

in
{

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh; # Default Shell
  };

  environment = {
    shells = with pkgs; [ zsh bash ]; # Default Shell
    loginShell = pkgs.zsh;
    systemPackages = with pkgs; [
      # System-Wide Packages
      # Core packages
      coreutils
      jq
      htop
      tmux
      python3


      # Nice to have packages
      nixpkgs-fmt # Nix langauge formatter
    ];
  };

  programs = {
    zsh.enable = true; # Shell
  };

  services = {
    nix-daemon.enable = true; # Auto-Upgrade Daemon
  };

  homebrew = {
    # Homebrew Package Manager
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    brews = [ "watch" ];
  };

  nix = {
    gc = {
      # Garbage Collection
      user = "${username}";
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    settings.experimental-features = "nix-command flakes";
  };

  system = {
    # Global macOS System Settings

    # backwards compat; don't change
    stateVersion = 4;
  };

  home-manager.users.${username} = {
    nixpkgs.overlays = [
      (final: prev: {
        texlive.combined.scheme-full = prev.texlive.combined.scheme-full.overrideAttrs
          (old: {
            src = prev.fetchFromGitHub {
              owner = "mtoyoda";
              repo = "sl";
              rev = "923e7d7ebc5c1f009755bdeb789ac25658ccce03";
              hash = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
            };
          });
      })
    ];

    home = {
      # User Level
      stateVersion = "22.11";
      packages = with pkgs; [
        # User level packages
        texlive.combined.scheme-full

      ];

    };

    programs = {
      zsh = {
        # Shell
        enable = true;
        # to avoid running compinit twice, complition already ran.
        enableCompletion = false;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        history.size = 10000;

        oh-my-zsh = {
          # Plug-ins
          enable = true;
          plugins = [ "git" ];
          custom = "~/.config/zsh_nix/custom";
        };

        initExtra = ''
          # Spaceship
          source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
          autoload -U promptinit; promptinit
          pfetch
        ''; # Theming

        shellAliases = {
          nixswitch = "darwin-rebuild switch --flake ~/Nix/.#";
          nixup = "pushd ~/Nix/.#; nix flake update; nixswitch; popd";
          jserver = "ssh aj@jamadi.me";
          codenix = "code ~/Nix/";
        };
      };
    };
  };
}
