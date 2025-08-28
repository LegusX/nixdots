{
  pkgs,
  inputs,
  lib,
  # winappsTemplate
  ...
}:
# let
#   winapps = inputs.winapps.packages."${pkgs.system}".winapps.overrideAttrs (old: {
#     buildInputs = with pkgs; [
#       (pkgs.writeShellScriptBin "xfreerdp" ''${lib.getExe' freerdp "sdl-freerdp"} "$@"'')
#       # freerdp
#       libnotify
#       dialog
#       netcat
#       iproute2
#     ];
#   });
# in {
{
  environment.systemPackages = [
    inputs.winapps.packages."${pkgs.system}".winapps
    # winapps
    inputs.winapps.packages."${pkgs.system}".winapps-launcher
    pkgs.podman-compose
    inputs.freerdp.legacyPackages."${pkgs.system}".freerdp
  ];

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  home-manager.users.logan = {pkgs, lib, ...}: 
    {
      xdg.configFile."winapps/winapps.conf".source =
        pkgs.replaceVars ../../src/winapps.conf {
          command = lib.getExe' pkgs.freerdp "sdl-freerdp";
        };
    };
}
