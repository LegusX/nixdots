{
  outputs,
  pkgs,
  lib,
  ...
}: {
  # imports = [
  #   outputs.modules.steamlibrary
  # ];

  # services.steamlibrary = lib.mkIf !services.steamlibrary.enable {
  #   enable = false;
  # };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    prismlaunchernew
  ];
}
