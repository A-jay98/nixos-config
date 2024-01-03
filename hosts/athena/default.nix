{ config, pkgs, vars, inputs, lib, ... }:

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






  environment = {
    variables = {
      # Environment Variables
    };
    systemPackages = with pkgs; [
      # System Wide Packages
      docker-compose
    ];
  };

  # No access is required by default.
  networking.firewall.enable = false;


  virtualisation.docker.enable = true;

  systemd.services.authentik = {
    path = [ pkgs.docker-compose ];
    script = ''
      docker-compose -f ${/authentik/docker-compose.yml} up -d
    '';
    wantedBy = [ "multi-user.target" ];
    # If you use docker
    after = [ "docker.service" "docker.socket" ];
  };


  # services.openssh = {
  #   # SSH
  #   enable = true;
  #   ports = [ 60 ];
  #   settings = {
  #     PasswordAuthentication = false;
  #     KbdInteractiveAuthentication = false;
  #     PermitRootLogin = "no";
  #   };
  #   allowSFTP = true; # SFTP
  #   extraConfig = ''
  #     HostKeyAlgorithms +ssh-rsa
  #   '';
  # };

  # # custom default user conf
  # users.users.${vars.user} = {
  #   openssh.authorizedKeys.keys = [
  #     "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZsVHhI2OjDFDl3t1ffvlOTZKZeoxoTH1NEcuQcV6uWVyBiWhsL5eJoGXC4VETMkxWwZtdMkDeFtFp/LVR20BoKAYgN9ge46DP+wStZbuoASzEu0cIupKnPxk2YLKr6VFJwE/jfeYY/MEm0C3givMfBxCZIGexWtvX9lm2+BO6QHuMO/bMKdKhIpGa4L6BYFj97EvIYzDSrk41rzq+p8mIOq6ESltmYDVlCjW6giJyX9bngSz+ZcKqEkU1nr30lDnyIXRSNFW2FJAkCm72dxWLfgx9hzyTsSiiuBz5b1ekVXFIYu7JiErOAlTsFA+P8CIx/nQ5Xnv5vNLpT5Z0W1rD Alis-MacBook-Pro"
  #   ];
  #   homeMode = "770";
  # };


}
