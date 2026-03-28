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
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.home-manager.nixosModules.home-manager
      ../users/logan
      ../modules/cli/default.nix
      ../modules/games/minecraft.nix
    ];

    services.minecraft.ryzenshine.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    time.timeZone = "America/New_York";

    networking.hostName = "meshy";

    services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1oHkRdSwpahozBf0cr1huRkipnnghPJnmv+5gmrQGB logan@ryzenshine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPFQUc4k8kzC/yS1VZWU+aBok6U7p4wW8WhEWLkw0r+r logan@loganthinkbook"
    ];

    
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    # Hardware config

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    fileSystems = {
      "/" = {
        device  = "/dev/disk/by-uuid/f93ef002-586d-4190-9664-ad719debac87";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/4C2A-F621";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
      "/mnt/slow2tb" = {
        device = "/dev/disk/by-uuid/1265c8be-73fd-4002-a404-109101bab17b";
        fsType = "btrfs";
        options = ["compress=zstd" "noatime" "x-gvfs-show" "nofail"];
      };
      "/mnt/slow1tb" = {
        device = "/dev/disk/by-uuid/19731e86-c60d-4a19-b3a2-d5e5e3f74be6";
        fsType = "btrfs";
        options = ["compress=zstd" "noatime" "x-gvfs-show" "nofail"];
      };
    };

    swapDevices = [
      {
        device = "/dev/disk/by-uuid/d60abc7c-3793-4d87-b2ef-31cb825354ea";
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    system.stateVersion = "25.11";
  }
