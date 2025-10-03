{
  config,
  pkgs,
  inputs,
  osConfig,
  lib,
  ...
}: {
  imports = [
  ];

  # programs.btop.extraConfig = builtins.readFile (osConfig.scheme inputs.theme-btop);
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
    };
  };
  
  # programs.alacritty.settings = builtins.fromTOML (builtins.readFile (osConfig.scheme inputs.theme-alacritty));
  # programs.alacritty.enable = true;
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "ashen";
      background-opacity = 0.9;
      confirm-close-surface = false;
    };
  };

  home.file."${config.xdg.configHome}/ghostty/themes/ashen" = {
    text = builtins.readFile (inputs.ashen + "/ghostty/ashen");
  };

  home.file."${config.xdg.configHome}/swayosd/style.css" = {
    text = (builtins.readFile (osConfig.scheme inputs.theme-waybar)) + (builtins.readFile ../../src/swayosd.css);
  };

  # programs.wofi.style = (builtins.readFile (osConfig.scheme inputs.theme-waybar)) + (builtins.readFile ../../src/wofi.css);
  # programs.wofi.enable = true;

  home.packages = with pkgs; [
    (colloid-gtk-theme.override {themeVariants = ["all"];})
    (colloid-icon-theme.override {colorVariants = ["all"];})
    vimix-cursors
    twitter-color-emoji
    nerd-fonts.roboto-mono
  ];

  programs.helix.settings.theme = lib.mkForce "ashen";
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

  home.pointerCursor = {
    name = lib.mkForce "Vimix-cursors";
    gtk.enable = true;
    x11.enable = true;
    package = lib.mkForce pkgs.vimix-cursors;
  };

  gtk.theme.package = pkgs.colloid-gtk-theme.override {themeVariants = ["all"];};
  gtk.theme.name = "Colloid-Orange-Dark";

  gtk.iconTheme.package = pkgs.colloid-icon-theme.override {colorVariants = ["all"];};
  gtk.iconTheme.name = "Colloid-Orange-Dark";

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

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
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
        package = pkgs.nerd-fonts.roboto-mono;
        name = "RobotoMono Nerd Font";
      };
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
    };
    cursor = {
      package = lib.mkForce pkgs.vimix-cursors;
      name = lib.mkForce "Vimix-cursors";
      size = 12;
    };
  };
}
