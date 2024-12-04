{
  config,
  pkgs,
  inputs,
  osConfig,
  lib,
  ...
}: {
  imports = [
    ./waybar.nix
    ./wallust.nix
  ];

  programs.btop.extraConfig = builtins.readFile (osConfig.scheme inputs.theme-btop);
  programs.btop.enable = true;

  programs.alacritty.settings = builtins.fromTOML (builtins.readFile (osConfig.scheme inputs.theme-alacritty));
  programs.alacritty.enable = true;

  home.file."${config.xdg.configHome}/swayosd/style.css" = {
    text = (builtins.readFile (osConfig.scheme inputs.theme-waybar)) + (builtins.readFile ../../src/swayosd.css);
  };

  programs.wofi.style = (builtins.readFile (osConfig.scheme inputs.theme-waybar)) + (builtins.readFile ../../src/wofi.css);
  programs.wofi.enable = true;

  home.packages = with pkgs; [
    (colloid-gtk-theme.override {themeVariants = ["all"];})
    (colloid-icon-theme.override {colorVariants = ["all"];})
    vimix-cursors
    twitter-color-emoji
    (nerdfonts.override {fonts = ["RobotoMono"];})
  ];

  programs.helix.settings.theme = lib.mkForce "custom";
  programs.helix.themes = with osConfig.scheme.withHashtag; {
    custom = {
      "inherits" = "ayu_dark";
      "palette" = {
        "background" = base00;
        "foreground" = base0F;
        "blue" = base0A;
      };
    };
  };

  gtk.theme.package = pkgs.colloid-gtk-theme.override {themeVariants = ["all"];};
  gtk.theme.name = "Colloid-Orange-Dark";

  gtk.iconTheme.package = pkgs.colloid-icon-theme.override {colorVariants = ["all"];};
  gtk.iconTheme.name = "Colloid-orange-dark";

  gtk.cursorTheme = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
  };

  gtk.gtk3.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=0
    '';
  };

  gtk.gtk4.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=0
    '';
    gtk-theme-name = ''Colloid-Orange-Dark'';
  };

  home.sessionVariables.GTK_THEME = "Colloid-Orange-Dark";

  stylix = {
    image = ../../src/wallpaper.gif;
    enable = true;
    autoEnable = false;
    # base16Scheme = ../../src/base16_theme.yaml;
    # polarity = "dark";
    # targets = {
    #   gnome.enable = true;
    #   gtk.enable = true;
    #   xfce.enable = true;
    # };
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
}
