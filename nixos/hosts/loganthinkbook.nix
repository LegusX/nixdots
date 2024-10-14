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
    # outputs.nixosModules.gifWallpaper
  ];

  networking.hostName = "loganthinkbook";
  networking.networkmanager.enable = true;
  # services.resolved.enable = true;

  boot.loader.systemd-boot.enable = true;
  services.logind.lidSwitch = "hybrid-sleep";

  users.users = {
    logan = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "audio"];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDagHYo50nLw9/0VtVI2WbjOz6oz7dM+D6YMsR8nHXKqfhErQBleuvcwnnhLUr3LjsyF3RVtYUf+WYSFnwz+0ZBJNtMdqLJg0OsPXsM1ugbZlx4ZVNb1uMm2vZ1cer0DbDqAQsWwVsB3Z+E5VbUmcpRNFFbRhR9bd5/b3qPV+wHoGriAIkcFHcJ1HKTksHcFh27MYPqBkNcOkPjAPk1Vtr53v/4JK7Q7Z6CyJagw/axuNEmGlXDDvfN8vPfwxsR47VOjjqk9l1rhLODl+XLZKXtTbRr3+mKcVirBhMX0fPZ+FxVVraH741tlVuWrlyuECfPiVRLWo+TH/P4asxZxpnp9exXJ/miofPRJemtwm076MJm7Tw6EVlJynfY34iaA4ZWJCPOQCSIj4krzAcTf1OhxGsmlwoNpVecYoUVYaLZ6eiAhb1YGbm15vGwpf3IW1vPF+v09OiR+E5XbwOTCxY6Kk5XEgjqAjRENdvK/qP70XcjLt+5zThFh9FDS8e+Ry0= logan@ryzen-shine"
      ];
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

  # stylix.enable = true;
  # stylix.image = config.services.gifWallpaper.png;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      logan = import ../../home-manager/logan-desktop.nix;
      becca = import ../../home-manager/becca.nix;
    };
  };

  programs.zsh.enable = true;

  #Hardware configuration

  networking.dnsExtensionMechanism = lib.mkForce false;

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
