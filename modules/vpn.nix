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
    services.mullvad-vpn.package = pkgs.mullvad-vpn;
    services.mullvad-vpn.enableExcludeWrapper = false;
    services.resolved.enable = true;
    networking.resolvconf.enable = false;

    system.activationScripts.noMullvadLockdown = {
      supportsDryActivation = true;
      text = ''
        if [ "$NIXOS_ACTION" = 'dry-activate' ]; then
          echo "Dry run: mullvad lockdown-mode off"
        else
          ${pkgs.mullvad}/bin/mullvad lockdown-mode set off
        fi
      '';
    };
  };
}
