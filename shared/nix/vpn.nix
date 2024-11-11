{pkgs, ...}: {
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.unstable.mullvad-vpn;
  services.resolved.enable = true;
  networking.resolvconf.enable = false;
}
