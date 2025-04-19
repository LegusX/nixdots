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
    ../modules/desktops/winapps.nix
  ];

  # desktops.gnome.enable = false;
  hyprland.enable = false;
  desktops.sway.enable = false;
  games.enable = true;
  services.minecraft.ryzenshine.enable = true;
  users.becca.enable = true;

  # Jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    mediaelch
    radarr
    unstable.sonarr
  ];
  # hopefully fixed soon
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  services.prowlarr = {
    enable = true;
  };

  # services.radarr.enable = true;
  
  networking.hostName = "ryzenshine";
  networking.networkmanager.enable = true;
  # time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # graphics nonsense
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Theming
  stylix = {
    enable = true;
    autoEnable = false;
    image = ../src/wallpaper.gif;
    polarity = "dark";
    # base16Scheme = ../src/base16_theme.yaml;
  };

  #speed thing ig?
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  ###################################################################################################
  # Hardware Config
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.kernelParams = ["preempt=full"];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      devices = ["nodev"];
      useOSProber = true;
      efiSupport = true;
    };
  };

  #Sound nonsense for games over hdmi
  services.pipewire.wireplumber.extraConfig."99-fix-games" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_output.pci-0000_2d_00.1.hdmi-stereo";
          }
        ];
        actions = {
          update-props={
            "api.alsa.headroom" = "2048";
          };
        };
      }
    ];
  };
  
  boot.kernelPackages = pkgs.linuxPackages_6_12;

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
      # Windows Install
      # SSD = {
      #   device = "/dev/nvme1n1";
      #   type = "disk";
      #   content = {
      #     type = "gpt";
      #     partitions = {
      #       FAST = {
      #         name = "FAST";
      #         size = "100%";
      #         content = {
      #           type = "btrfs";
      #           extraArgs = ["-f" "-L" "FAST"];
      #           mountpoint = "/mnt/fast";
      #           mountOptions = ["compress=zstd" "noatime" "x-gvfs-show" "nofail"];
      #         };
      #       };
      #     };
      #   };
      # };
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
