{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland.enable = true;

  environment.loginShellInit = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec dbus-launch Hyprland
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
  ];

  #xdg.portal = {
  #  enable = true;
  #  extraPortals = with pkgs; [
  #    xdg-desktop-portal-gtk
  #  ];
  #};

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
}
