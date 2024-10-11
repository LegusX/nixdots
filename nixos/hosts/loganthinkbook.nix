{
  pkgs,
  inputs,
  outputs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (modulesPath + "/installer/scan/not-detected.nix")
    # outputs.nixosModules.gifWallpaper
  ];

  networking.hostName = "loganthinkbook";

  boot.loader.systemd-boot.enable = true;
  services.logind.lidSwitch = "hybrid-sleep";

  users.users = {
    logan = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "audio"];
    };
    becca = {
      isNormalUser = true;
    };
  };

  # services.gifWallpaper = {
  #   enable = true;
  #   dir = ../../src/wallpapers;
  #   random = builtins.toString (builtins.getEnv "$RANDOM");
  # };

  xdg.autostart.enable = !config.services.xserver.desktopManager.gnome.enable;
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = !config.services.xserver.desktopManager.gnome.enable;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };
  programs.dconf.enable = true;

  # stylix.enable = true;
  # stylix.image = config.services.gifWallpaper.png;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      logan = import ../../home-manager/logan.nix;
      becca = import ../../home-manager/becca.nix;
    };
  };

  programs.zsh.enable = true;

  #Hardware configuration

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b427321b-d2e3-4e31-9eea-bceabaf95b9b";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7086-D615";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/0c3aac5a-c570-4e72-8be1-d1bf13e66eb6"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
