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
    alacritty
  ];

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
    stylePath = "${config.xdg.configHome}/swayosd/style.css";
  };

  wayland.windowManager.river = {
    enable = true;
    settings = {
      border-width = 2;
    };
  };

  programs.gauntlet = {
    enable = true;
    service.enable = true;
    
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
