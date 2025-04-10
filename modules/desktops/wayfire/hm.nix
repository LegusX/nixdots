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
    inputs.gauntlet.homeManagerModules.default
    (inputs.home-manager-unstable + "/modules/services/window-managers/wayfire.nix")
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

  programs.gauntlet = {
    enable = true;
    service.enable = true;
  };

  wayland.windowManager.wayfire = {
    enable = true;
    package = null;
    settings = {
      core = {
        plugins = lib.concatStringsSep " " [
          "animate"
          "command"
          # "decoration"
          "foreign-toplevel"
          "ipc"
          "gtk-shell"
          "simple-tile"
          "wm-actions"
        ]
      }
    }
  };
}
