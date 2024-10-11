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
    enable = true;
    # mounts = lib.mkDefault [
    #   {
    #     soruce = "/opt/steam/library";
    #     dirName = "library";
    #     label = "Steam Library";
    #   }
    # ];
    # root = lib.mkDefault /opt/steam;
  };

  programs.java.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    # package = pkgs.steam.override { privateTmp = false; };
  };

  environment.systemPackages = with pkgs; [
    prismlaunchernew
  ];
}
