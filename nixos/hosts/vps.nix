{
  config,
  pkgs,
  inputs,
  outputs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  networking.hostName = "logan-vps";
  users.users = {
    logan = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel"];
      initialPassword = "pleasepasswdnow";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDg9USVFHk+6yHSutbFAa0KOTz71zZikc5TmGY3vnPic logan@nixos"
      ];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      logan = import ../../home-manager/logan.nix;
    };
  };

  programs.zsh.enable = true;

  # Disk formatting
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              end = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "bcachefs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_scsi"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.tmp.useTmpfs = false;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
}
