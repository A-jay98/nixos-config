{ config, pkgs, vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    # Boot Options
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit=5;
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


  services = {
    openssh = {
      # SSH
      enable = true;
      ports = [ 60 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      allowSFTP = true; # SFTP
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
  };

  users.users.${vars.user}.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZsVHhI2OjDFDl3t1ffvlOTZKZeoxoTH1NEcuQcV6uWVyBiWhsL5eJoGXC4VETMkxWwZtdMkDeFtFp/LVR20BoKAYgN9ge46DP+wStZbuoASzEu0cIupKnPxk2YLKr6VFJwE/jfeYY/MEm0C3givMfBxCZIGexWtvX9lm2+BO6QHuMO/bMKdKhIpGa4L6BYFj97EvIYzDSrk41rzq+p8mIOq6ESltmYDVlCjW6giJyX9bngSz+ZcKqEkU1nr30lDnyIXRSNFW2FJAkCm72dxWLfgx9hzyTsSiiuBz5b1ekVXFIYu7JiErOAlTsFA+P8CIx/nQ5Xnv5vNLpT5Z0W1rD Alis-MacBook-Pro"
  ];



}
