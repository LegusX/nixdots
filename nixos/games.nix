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
    mounts = lib.mkDefault [
      {
        soruce = "/opt/steam/library";
        dirName = "library";
        label = "Steam Library";
      }
    ];
    root = lib.mkDefault /opt/steam;
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
