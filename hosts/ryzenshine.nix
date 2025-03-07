{
  pkgs,
  inputs,
  outputs,
  config,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (modulesPath + "/installer/scan/not-detected.nix")
    ./common.nix
    ../modules
    ../users
  ];

  desktops.gnome.enable = false;
  hyprland.enable = true;
  games.enable = true;
  services.minecraft.ryzenshine.enable = true;
  users.becca.enable = true;

  networking.hostName = "ryzenshine";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";

  # graphics nonsense
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # hardware.amdgpu.amdvlk = {
  #     enable = true;
  #     support32Bit.enable = true;
  # };

  # Theming
  stylix = {
    enable = true;
    autoEnable = false;
    image = ../src/wallpaper.gif;
    polarity = "dark";
    # base16Scheme = ../src/base16_theme.yaml;
  };

  ###################################################################################################
  # Hardware Config
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.loader.systemd-boot.enable = true;
  # boot.kernelPackages = pkgs.linuxPackages_cachyos; # Custom kernel because why not

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  #################
  # Disko Setup
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              end = "-16G";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                mountpoint = "/";
                mountOptions = ["compress=zstd" "noatime"];
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = false;
              };
            };
          };
        };
      };
      SSD = {
        device = "/dev/nvme1n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            FAST = {
              name = "FAST";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f" "-L" "FAST"];
                mountpoint = "/mnt/fast";
                mountOptions = ["compress=zstd" "noatime" "x-gvfs-show" "nofail"];
              };
            };
          };
        };
      };
      HDD = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            SLOW = {
              name = "SLOW";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f" "-L" "SLOW"];
                mountpoint = "/mnt/slow";
                mountOptions = ["compress=zstd" "noatime" "x-gvfs-show" "nofail"];
              };
            };
          };
        };
      };
    };
  };

  system.stateVersion = "24.11";
}
