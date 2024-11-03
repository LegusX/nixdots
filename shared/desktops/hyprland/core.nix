{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  programs.hyprland.enable = true;

  home-manager.sharedModules = [./hm.nix];

  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec dbus-run-session Hyprland
    fi
  '';
  environment.systemPackages = with pkgs; [
    gnome.nautilus
    wl-gammactl
    wl-clipboard
    pavucontrol
    brightnessctl
    hyprshot
    wofi
    swww
    xdg-utils
    gnome.eog
    overskride
    networkmanagerapplet
  ];

  security = {
    polkit.enable = true;
    pam.services.ags = {};
  };

  services = {
    gvfs.enable = true;
    gnome = {
      gnome-keyring.enable = true;
    };
  };

  #xdg nonsense, I don't even know what parts of this are necessarry anymore
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

  #make sure background is set
  # TODO: Point to static wallpaper
  # system.userActivationScripts = {
  #   changeWallpaper.text = ''
  #     ${pkgs.swww}/bin/swww img ${config.services.gifWallpaper.gif}
  #   '';
  # };
}
