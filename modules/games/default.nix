{
  outputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./minecraft.nix
  ];

  options = {
    games.enable = lib.mkEnableOption "Enable games module";
  };

  config = lib.mkIf config.games.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      heroic
      protontricks
      (prismlauncher.override {
        # withWaylandGLFW = true;
        jdks = with pkgs; [
          jdk21
          graalvm-ce
        ];
      })
    ];
  };
}
