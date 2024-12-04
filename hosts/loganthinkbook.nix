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

  xdg.autostart.enable = true;
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = true;
    extraPortals = lib.mkForce (with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ]);
  };
  programs.dconf.enable = true;

  # Enable GDM login manager
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;

  # Enable LightDM
  # services.xserver = {
  #   enable = true;
  #   displayManager.lightdm = {
  #     enable = true;
  #   };
  # };

  # Enable greetd
  # Autologin to logan and then start hyprlock from hyprland
  # services.greetd = {
  #   enable = true;
  #   settings = rec {
  #     initial_session = {
  #       command = "dbus-run-session ${pkgs.hyprland}/bin/Hyprland";
  #       user = "logan";
  #     };
  #   };
  # };
  services.getty.autologinUser = "logan";
  home-manager.users.logan.wayland.windowManager.hyprland.settings.exec-once = [
    "hyprlock"
  ];

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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b427321b-d2e3-4e31-9eea-bceabaf95b9b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7086-D615";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/0c3aac5a-c570-4e72-8be1-d1bf13e66eb6";}
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
