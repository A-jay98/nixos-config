{ config, pkgs, vars, lib, ... }:

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

  services.openssh = {
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

  # custom default user conf
  users.users.${vars.user} = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZsVHhI2OjDFDl3t1ffvlOTZKZeoxoTH1NEcuQcV6uWVyBiWhsL5eJoGXC4VETMkxWwZtdMkDeFtFp/LVR20BoKAYgN9ge46DP+wStZbuoASzEu0cIupKnPxk2YLKr6VFJwE/jfeYY/MEm0C3givMfBxCZIGexWtvX9lm2+BO6QHuMO/bMKdKhIpGa4L6BYFj97EvIYzDSrk41rzq+p8mIOq6ESltmYDVlCjW6giJyX9bngSz+ZcKqEkU1nr30lDnyIXRSNFW2FJAkCm72dxWLfgx9hzyTsSiiuBz5b1ekVXFIYu7JiErOAlTsFA+P8CIx/nQ5Xnv5vNLpT5Z0W1rD Alis-MacBook-Pro"
    ];
    homeMode = "770";
  };



  services.cloudflared = {
    enable = true;
    tunnels = {
      "heracles" = {
        credentialsFile = "/var/lib/secrets/a9dee591-54ac-4c41-984c-8e71a5e34a40.json";
        default = "http_status:404";
        ingress =
          let
            defaultNginxAccess = {
              service = "https://localhost";
              originRequest.noTLSVerify = true; #TODO: fix this. 
            };
          in
          {
            "auth.jamadi.me" = defaultNginxAccess;
          };
      };
    };
  };
  # making the service more isolated and secure.
  systemd.services."cloudflared-tunnel-heracles".serviceConfig = {
    DynamicUser = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;

  };

}
