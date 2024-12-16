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
    ../users/groups/loganbecca.nix
  ];

  networking.hostName = "loganthinkbook";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  # services.resolved.enable = true;

  boot.loader.systemd-boot.enable = true;
  services.logind.lidSwitch = "hybrid-sleep";
  
  # graphics nonsense
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
      # libvdpau-va-gl
    ];
  };

  Greeter nonsense
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };


  # Theming
  stylix = {
    enable = true;
    # targets = {
    #   gtk.enable = true;
    #   gnome.enable = true;
    # };
    autoEnable = false;
    image = ../src/wallpaper.gif;
    polarity = "dark";
    # base16Scheme = ../src/base16_theme.yaml;
  };

  
  
  #Hardware configuration

  # networking.dnsExtensionMechanism = lib.mkForce false;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # Now controlled by disko
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/b427321b-d2e3-4e31-9eea-bceabaf95b9b";
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/7086-D615";
  #   fsType = "vfat";
  #   options = ["fmask=0077" "dmask=0077"];
  # };

  # swapDevices = [
  #   {device = "/dev/disk/by-uuid/0c3aac5a-c570-4e72-8be1-d1bf13e66eb6";}
  # ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Disk setup
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP={
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
                mountOptions = ["noatime"];
              };
            };
            swap = {
              size="100%";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };

}

