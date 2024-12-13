{
  pkgs,
  lib,
  ...
}:
{
  home-manager.sharedModules = [./hm.nix];

  environment.systemPackages = with pkgs; [
    nautilus
    wl-gammactl
    wl-clipboard
    pavucontrol
    brightnessctl
    hyprshot
    wofi
    swww
    xdg-utils
    eog
    overskride
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
    ];
  };

  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  services = {
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  xdg = {
    autostart.enable = true;
    portal = {
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = lib.mkForce (with pkgs; [
        xdg-desktop-portal-gtk
      ]);
    };
  };

  programs.dconf.enable = true;

  # hardware.graphics.enable = true;

  # Greeter nonsense
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
  
}
