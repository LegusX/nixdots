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
    # games.tft.enable = lib.mkEnableOption = "Enable waydroid for TFT";
  };

  config = lib.mkIf config.games.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = ["-O" "DP-2" "-W" "3840" "-H" "2160" "--hdr-enabled" "--adaptive-sync"];
        env = {
          "ENABLE_HDR_WSI"="1";
          "DXVK_HDR"="1";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      heroic
      protontricks
      lutris
      unstable.ryubing
      torzu
      steam-rom-manager
      (prismlauncher.override {
        # withWaylandGLFW = true;
        jdks = with pkgs; [
          jdk21
          graalvm-ce
        ];
      })
    ];

    virtualisation.waydroid.enable = true;
  };
}
