{ config, lib, pkgs, modulesPath, vars, ... }:

{
  imports = [ (modulesPath + "/profile/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };


  swapDevices = [ ];

  networking = {
    useDHCP = false;
    hostName = vars.hostName;
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "10.0.0.206";
        prefixLength = 24;
      }];
    };
    defaultGateway = "10.0.0.10";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
