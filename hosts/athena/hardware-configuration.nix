{ config, lib, pkgs, modulesPath, vars, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  swapDevices = [ ];

  networking = {
    useDHCP = false;
    hostName = vars.hostName;
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "10.0.0.69";
        prefixLength = 16;
      }];
    };
    defaultGateway = "10.0.0.10";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
