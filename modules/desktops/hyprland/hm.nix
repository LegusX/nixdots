{
  pkgs,
  config,
  osConfig,
  inputs,
  ...
}: {
  imports = [
    ./hyprlock.nix
    inputs.walker.homeManagerModules.default
  ];
  home.sessionVariables.NIXOS_OZONE_WL = "1";

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

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      websearch.prefix = "?";
      AppLaunchPrefix = "uwsm app --";
    };
  };

  # programs.gauntlet = {
  #   enable = true;
  #   service.enable = true;
  # };
  

  xdg.configFile."hypr/hyprland.conf" = {
    # source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/hyprland.conf";
    source = ../../../config/hyprland.conf;
  };
}
