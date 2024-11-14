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
    kanagawa-gtk-theme
    kanagawa-icon-theme
    vimix-cursors
  ];

  gtk.theme.package = pkgs.kanagawa-gtk-theme;
  gtk.theme.name = "Kanagawa-BL";

  gtk.iconTheme.package = pkgs.kanagawa-icon-theme;
  gtk.iconTheme.name = "Kanagawa";

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

  home.sessionVariables.GTK_THEME = "Kanagawa";
}
