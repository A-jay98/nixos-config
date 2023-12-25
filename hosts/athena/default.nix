{ config, pkgs, vars, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    # Boot Options
    loader = {
      grub = {
        device = "/dev/sda";
        configurationLimit = 5;
      };
      timeout = 1;
    };
  };


  users.users.${vars.user} = {
    # System User
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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



  environment = {
    variables = {
      # Environment Variables
    };
    systemPackages = with pkgs; [
      # System Wide Packages

    ];
  };

  # No access is required by default.
  networking.firewall.enable = false;

  services.authentik = {
    enable = true;
    # The environmentFile needs to be on the target host!
    # Best use something like sops-nix or agenix to manage it
    environmentFile = "/secrets/authentik/authentik-env";
    settings = {
      # email = {
      #   host = "smtp.example.com";
      #   port = 587;
      #   username = "authentik@example.com";
      #   use_tls = true;
      #   use_ssl = false;
      #   from = "authentik@example.com";
      # };
      disable_startup_analytics = true;
      avatars = "initials";
    };
  };


}