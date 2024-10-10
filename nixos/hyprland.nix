{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.hyprland.enable = true;

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
    swaylock-effects
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

  #make sure background is set
  system.userActivationScripts = {
    changeWallpaper.text = ''
      ${pkgs.swww}/bin/swww img ${config.services.gifWallpaper.gif}
    '';
  };
}
