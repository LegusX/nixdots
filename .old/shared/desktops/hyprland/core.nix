{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  programs.hyprland.enable = true;
  programs.hyprland.package = pkgs.unstable.hyprland;

  hardware.graphics = {
    enable = true;
    package = pkgs.unstable.mesa.drivers;
    # enable32Bit = true;
    # package32 = pkgs.unstable.pkgsi686Linux.mesa.drivers;
  };

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

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };

  security = {
    polkit.enable = true;
    # pam.services.ags = {};
    pam.services.hyprlock = {};
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
