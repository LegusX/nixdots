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

  hyprland.enable = true;
  users.becca.enable = true;

  networking.hostName = "ryzenshine";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";

  # graphics nonsense
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # intel-vaapi-driver
      # libvdpau-va-gl
    ];
  };


  # Theming
  stylix = {
    enable = true;
    autoEnable = false;
    image = ../src/wallpaper.gif;
    polarity = "dark";
    # base16Scheme = ../src/base16_theme.yaml;
  };

  ###################################################################################################
  # TODO Hardware Config

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
              name = "FAST"
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                mountpoint = "/mnt/fast";
                mountOptions = ["compress=zstd" "noatime"];
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
                extraArgs = ["-f"];
                mountpoint = "/mnt/slow";
                mountOptions = ["compress=zstd" "noatime"];
              };
            };
          };
        };
      };
    };
  };
}
