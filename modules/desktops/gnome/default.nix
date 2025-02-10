{
  lib,
  config,
  ...
}: {
  options = {
    desktops.gnome.enable = lib.mkEnableOption "enable gnome DE";
  };

  config = lib.mkIf config.desktops.gnome.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  };
}
