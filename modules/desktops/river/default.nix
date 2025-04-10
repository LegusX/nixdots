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
    desktops.river.enable = lib.mkEnableOption "Enable river";
  };

  config = lib.mkIf config.desktops.sway.enable {
    # imports = [
    #   inputs.gauntlet.nixosModules.default
    # ];
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

   #  programs.river = {
   #    enable = true;
   #    extraPackages = lib.mkForce [];
   #  };

   # programs.uwsm = {
   #  enable = true;
   #  waylandCompositors = {
   #    sway = {
   #      prettyName = "River uwsm";
   #      binPath = "${pkgs.river}/bin/river";
   #    };
   #  };
   # };
    
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
  };
}
