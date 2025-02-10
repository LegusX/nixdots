{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../hyprland/hyprlock.nix
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    cliphist
    waybar
    udiskie
    swaynotificationcenter
    wl-clipboard
    alacritty
  ];

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
    stylePath = "${config.xdg.configHome}/swayosd/style.css";
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      terminal = "alacritty";
    };
  };
}
