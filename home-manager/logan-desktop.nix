{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./firefox.nix
    ./logan.nix
  ];
  
  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    opacity = {
      desktop = 0.3;
      terminal = 0.4;
      popups = 0.3;
    };
    targets = {
      avizo.enable = true;
      alacritty.enable = true;
      kitty.enable = true;
      btop.enable = true;
      dunst.enable = true;
      firefox.enable = true;
      gnome.enable = true;
      gtk.enable = true;
      helix.enable = false;
      hyprland.enable = true;
      # hyprpaper.enable = true;
      # kde.enable = true;
      swaylock.enable = true;
      # wofi.enable = true;
    };

    fonts = {
      sansSerif = {
        package = pkgs.roboto;
        name = "Roboto";
      };
      serif = {
        package = pkgs.roboto;
        name = "Roboto";
      };
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["RobotoMono"];};
        name = "RobotoMono Nerd Font";
      };
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
    };
    cursor = {
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
      size = 12;
    };
  };
  
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
  ];
  
}
