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
    };

    environment.systemPackages = with pkgs; [
      heroic
      (prismlauncher.override {
        jdks = with pkgs; [
          jdk21
          graalvm-ce
        ];
      })
    ];
  };
}
