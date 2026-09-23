{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    vpn.enable = lib.mkEnableOption "Enable vpn";
  };
  config = lib.mkIf config.vpn.enable {
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.unstable.mullvad-vpn;
    services.mullvad-vpn.enableExcludeWrapper = false;
    services.resolved.enable = true;
    networking.resolvconf.enable = false;
  };
}
