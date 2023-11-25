{ config, pkgs, vars, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/services/samba.nix
  ];

  boot = {
    # Boot Options
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 1;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };


  environment =
    let
      oldpkgs = import inputs.nixpkgs_ltex-ls { system = "x86_64-linux"; };
    in
    {
      systemPackages = with pkgs; [
        # System Wide Packages
        texlive.combined.scheme-full
        pciutils
      ] ++
      [
        oldpkgs.ltex-ls
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

  # custom default user conf
  users.users.${vars.user} = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZsVHhI2OjDFDl3t1ffvlOTZKZeoxoTH1NEcuQcV6uWVyBiWhsL5eJoGXC4VETMkxWwZtdMkDeFtFp/LVR20BoKAYgN9ge46DP+wStZbuoASzEu0cIupKnPxk2YLKr6VFJwE/jfeYY/MEm0C3givMfBxCZIGexWtvX9lm2+BO6QHuMO/bMKdKhIpGa4L6BYFj97EvIYzDSrk41rzq+p8mIOq6ESltmYDVlCjW6giJyX9bngSz+ZcKqEkU1nr30lDnyIXRSNFW2FJAkCm72dxWLfgx9hzyTsSiiuBz5b1ekVXFIYu7JiErOAlTsFA+P8CIx/nQ5Xnv5vNLpT5Z0W1rD Alis-MacBook-Pro"
    ];
    homeMode = "770";
  };

  # all other users settings
  users.users."shiva" = {
    isNormalUser = true;
    homeMode = "770";
    # TODO: This is nice. Heracles can server these files.
    # openssh.authorizedKeys.keys =
    #   let
    #     authorizedKeys = pkgs.fetchurl {
    #       url = "https://secrets.jamadi.me/ssh/shiva/jnix.pub";
    #       sha256 = "1kril7clfay225xdfhpp770gk60g5rp66nr6hzd5gpxvkynyxlrf";
    #     };
    #   in
    #   pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDibAV8VYRGzs2Dy+iTVQlJssAX2J1HyizPzK+Twoe/T/l0dB9+GhVt00R6qm5SPU9CmmbTQePDZ+Bjxx1Gw1sTVPV7gBbPUa4yg4dKGIobdb+rY7L7RPU274K6AF9Hpp6Yn5M3UEhnPi9uUphEl+0YC+bsbB54A1ozoSmFbtFt7z7YwCTfkLU6yu9TiWw1xZI/HL2rwsBoTgPWC9Ld0FH9oycu0aN6QvfRo4BkquCnV2MJCHAZHEAJVkGK79FBo3ylHJz/rXFRrQ+v3PdHnGUpw1NAvki6DajX6hRa8UE4v4xuOvspSpm6+HIxOOXlGd8579Vy7DPKw6SjUkY5e8XZ shiva"
    ];


    shell = pkgs.zsh;
  };

}
