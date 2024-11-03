{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../shared/desktops/hyprland/hm.nix
    ../../shared/home-manager/firefox.nix
    ./core.nix
  ];

  # stylix = {
  #   enable = false;
  #   autoEnable = false;
  #   base16Scheme = ../src/kanagawa.yaml;
  #   polarity = "dark";
  #   opacity = {
  #     desktop = 0.3;
  #     terminal = 0.4;
  #     popups = 0.3;
  #   };
  #   targets = {
  #     avizo.enable = true;
  #     alacritty.enable = true;
  #     kitty.enable = true;
  #     btop.enable = true;
  #     dunst.enable = true;
  #     firefox.enable = true;
  #     # gnome.enable = true;
  #     # gtk.enable = true;
  #     helix.enable = false;
  #     hyprland.enable = true;
  #     # hyprpaper.enable = true;
  #     # kde.enable = true;
  #     swaylock.enable = true;
  #     # wofi.enable = true;
  #   };

  #   fonts = {
  #     sansSerif = {
  #       package = pkgs.roboto;
  #       name = "Roboto";
  #     };
  #     serif = {
  #       package = pkgs.roboto;
  #       name = "Roboto";
  #     };
  #     monospace = {
  #       package = pkgs.nerdfonts.override {fonts = ["RobotoMono"];};
  #       name = "RobotoMono Nerd Font";
  #     };
  #     emoji = {
  #       package = pkgs.twitter-color-emoji;
  #       name = "Twitter Color Emoji";
  #     };
  #   };
  #   cursor = {
  #     package = pkgs.vimix-cursors;
  #     name = "Vimix-cursors";
  #     size = 12;
  #   };
  # };

  gtk.theme.package = pkgs.kanagawa-gtk-theme;
  gtk.theme.name = "Kanagawa-BL";

  gtk.iconTheme.package = pkgs.kanagawa-icon-theme;
  gtk.iconTheme.name = "Kanagawa";

  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
  };

  home.packages = with pkgs; [
    obsidian
    vscode-fhs
    spotify
    kanagawa-gtk-theme
    kanagawa-icon-theme
  ];
}
