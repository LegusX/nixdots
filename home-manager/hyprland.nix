{pkgs, ...}:{
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
  }
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.pointerCursor = {
    gtk.enable = true
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 16;
  };
}
