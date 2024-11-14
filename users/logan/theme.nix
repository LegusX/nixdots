{
  config,
  pkgs,
  inputs,
  osConfig,
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

  home.packages = with pkgs; [
    (colloid-gtk-theme.override {themeVariants = ["all"];})
    (colloid-icon-theme.override {colorVariants = ["all"];})
    vimix-cursors
    twitter-color-emoji
    (nerdfonts.override {fonts = ["RobotoMono"];})
  ];

  gtk.theme.package = pkgs.colloid-gtk-theme;
  gtk.theme.name = "Colloid-Orange-Dark";

  gtk.iconTheme.package = pkgs.colloid-icon-theme;
  gtk.iconTheme.name = "Colloid-orange-dark";

  gtk.cursorTheme = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
  };

  gtk.gtk3.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
  };

  gtk.gtk4.extraConfig = {
    Settings = ''
      gtk-application-prefer-dark-theme=1
    '';
  };

  home.sessionVariables.GTK_THEME = "Colloid";

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
