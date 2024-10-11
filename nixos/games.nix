{
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    outputs.nixosModules.steamlibrary
  ];

  services.steamlibrary = {
    enable = false;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    prismlaunchernew
  ];
}
