{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/services/nginx.nix
    ./nginx.nix
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

  environment = {
    systemPackages = with pkgs; [
      # System Wide Packages

    ];
  };
  networking.firewall.enable = false;


}
