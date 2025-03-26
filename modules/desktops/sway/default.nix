{
  config, pkgs, lib, ...
}:
let
  inherit (lib) concatStringsSep getExe;
  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/wayland-sessions"
    "${sessionData}/share/xsessions"
  ];
  tuigreet = getExe pkgs.greetd.tuigreet;
in {
  options = {
    desktops.sway.enable = lib.mkEnableOption "Enable sway";
  };

  config = lib.mkIf config.desktops.sway.enable {
    # assertions = [
    #   {
    #     assertion = config.hyprland.enable;
    #     message = "Cannot enable sway and hyprland at the same time because hyprland sucks";
    #   }
    # ];
    
    # import = [
      # ./regreet.nix
    # ];

    home-manager.sharedModules = [
      ./hm.nix
      ./waybar.nix
    ];

    programs.sway = {
      enable = true;
      package = pkgs.unstable.swayfx;
      wrapperFeatures.gtk = true;
      extraPackages = lib.mkForce [];
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
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = concatStringsSep " " [
            tuigreet
            "-g 'Welcome to NixOS!'"
            "--asterisks"
            "--remember"
            "--remember-user-session"
            "--time"
            "--sessions '${sessionPath}'"
          ];
          user = "greeter";
        };
      };
    };
  };
}
