{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    desktops.wayfire.enable = lib.mkEnableOption "Enable wayfire";
  };

  config = lib.mkIf config.desktops.wayfire.enable {
    home-manager.sharedModules = [
      ./hm.nix
      ./waybar.nix
    ];

    programs.wayfire = {
      enable = true;
      plugins = with pkgs.wayfirePlugins; [
        wcm
        wayfire-plugins-extra
      ];
    };

    environment.systemPackages = with pkgs; [
      nautilus
      wl-gammactl
      wl-clipboard
      pavucontrol
      brightnessctl
      hyprshot
      # wofi
      swww
      xdg-utils
      eog
      overskride
      networkmanagerapplet
      autotiling
      sddm-astronaut
      # unstable.onagre
    ];

    services = {
      gvfs.enable = true;
      gnome = {
        gnome-keyring.enable = true;
      };
    };
    programs.dconf.enable = true;
    services.dbus.implementation = "broker";

    security = {
      polkit.enable = true;
      pam.services.hyprlock = {};
    };

    xdg.autostart.enable = true;
    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      theme = "sddm-astronaut-theme";
    };
    
    # xdg.configFile."wayfire.ini" = {
    #   source = lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixos-config/config/wayfire.ini";
    # };
  };
}
