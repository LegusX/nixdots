{
  pkgs,
  inputs,
  outputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
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

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      logan = import ../../home-manager/logan.nix;
      becca = import ../../home-manager/becca.nix;
    };
  };

  programs.zsh.enable = true;
}
