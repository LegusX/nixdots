{
  outputs,
  pkgs,
  lib,
  ...
}: {
  options = [
    games.enable = lib.mkEnableOption "Enable games module"
  ];
  config = lib.mkIf config.games.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      prismlauncher.override
      {jdks = [pkgs.jdk22];}
    ];
  };
}
