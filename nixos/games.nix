{
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    outputs.modules.steamlibrary
  ];

  # Only enable if the system doesn't have a specific configuration set up
  services.steamlibrary = lib.mkIf !services.steamlibrary.enable {
    enable = true;
    mounts = [
      {
        name = "Steam Library";
        source = 
      }
    ]
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
