{
  lib,
  pkgs,
  config,
  osConfig,
  inputs,
  ...
}: {
  imports = [
    # ./hyprlock.nix
    inputs.walker.homeManagerModules.default
    inputs.gauntlet.homeManagerModules.default
  ];
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";

  home.packages = with pkgs; [
    cliphist
    waybar
    udiskie
    swaynotificationcenter
    udiskie
    wl-clipboard
    # alacritty
  ];

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
    stylePath = "${config.xdg.configHome}/swayosd/style.css";
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.unstable.swayfx;
    systemd = {
      xdgAutostart = true;
      enable = true;
    };
    extraSessionCommands = ''
      export WLR_RENDERER=vulkan
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user restart pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk
    '';
    # extraConfigEarly = lib.readFile ../../../config/sway.conf;
    xwayland = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    checkConfig = false;
  };

  programs.gauntlet = {
    enable = true;
    service.enable = true;
  };

  programs.walker = {
    # enable = true;
    runAsService = true;

    config = {
      websearch.prefix = "?";
      # AppLaunchPrefix = "uwsm app --";
    };
  };

  xdg.configFile."sway/config" = {
    # source = config.lib.file.mk OutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/hyprland.conf";
    source = lib.mkForce ../../../config/sway.conf;
  };

  # xdg.configFile."uwsm/env" = {
  #   text = ''
  #     export
  #   ''
  # }
}
