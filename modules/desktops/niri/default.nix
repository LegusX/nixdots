{
  config, pkgs, lib, inputs, ...
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

    nixpkgs.overlays = [inputs.niri.overlays.niri];

    home-manager.sharedModules = [
      ./hm.nix
      ./waybar.nix
    ];

    programs.niri = {
      enable = true;
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
    ];

    services = {
      gvfs.enable = true;
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
