{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:     
  let
    inherit (lib) concatStringsSep getExe;
    sessionData = config.services.displayManager.sessionData.desktops;
    sessionPath = concatStringsSep ":" [
      "${sessionData}/share/wayland-sessions"
      "${sessionData}/share/xsessions"
    ];
    tuigreet = getExe pkgs.greetd.tuigreet;
    Hyprland = getExe config.programs.hyprland.package;
    pkgs-hypr = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    options = {
      hyprland.enable = lib.mkEnableOption "Enable Hyprland module";
    };

    config = lib.mkIf config.hyprland.enable {

      programs.hyprland = {
        # enable = true;
        # Use packages locked to hyprland version
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        withUWSM = true;
        xwayland.enable = false;
      };

      home-manager.sharedModules = [
      # {
      #   xdg.configFile."hypr/hyprland.conf" = {
      #     source = config.lib.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/hyprland.conf";
      #   };
      # }
      ./hm.nix
      ./waybar.nix
      ];

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
        networkmanagerapplet
      ];
      
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

      # Lock mesa version to hyprland version
      hardware.graphics = {
        package = pkgs-hypr.mesa.drivers;
        enable32Bit = true;
        # extraPackages32 = [pkgs-hypr.pkgsi686Linux.mesa.drivers];
      };

      # XDG nonsense. Not sure I need all of this
      xdg.autostart.enable = true;
      xdg.portal = {
        xdgOpenUsePortal = true;
        enable = true;
      };
      programs.dconf.enable = true;

      # Greeter
      services.greetd = {
        enable = true;
        settings = {
          # initial_session = {
          #   command = "${Hyprland}";
          #   user = "logan";
          # };
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
