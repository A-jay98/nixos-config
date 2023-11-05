{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    # Boot Options
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 5;
      };
      timeout = 1;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # System Wide Packages

    ];
  };
  networking.firewall.enable = false;

}
