{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    services.minecraft.ryzenshine.enable = lib.mkEnableOption "Enable ryzenshine minecraft server";
    services.minecraft.family.enable = lib.mkEnableOption "Enable family minecraft server";
  };

  config = {
    users.users.minecraft = {
      isSystemUser = true;
      group = "minecraft";
    };
    users.groups.minecraft = {};
    networking.firewall.allowedTCPPorts = [25565];

    systemd.services.minecraft-ryzenshine = lib.mkIf config.services.minecraft.ryzenshine.enable {
      enable = true;
      wants = ["network.target"];
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      description = "Ryzenshine Minecraft server";
      serviceConfig = {
        User = "minecraft";
        WorkingDirectory = "/opt/minecraft/ryzenshine";
        ExecStart = "${pkgs.jdk21}/bin/java -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar server.jar nogui";

        Restart = "always";
        RestartSec = "30";

        StandardInput = "null";
      };
    };
    systemd.services.minecraft-family = lib.mkIf config.services.minecraft.family.enable {
      enable = true;
      wants = ["network.target"];
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      description = "Family Minecraft server";
      serviceConfig = {
        User = "minecraft";
        WorkingDirectory = "/opt/minecraft/family";
        ExecStart = "${pkgs.jdk21}/bin/java -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar server.jar nogui";

        Restart = "always";
        RestartSec = "30";

        StandardInput = "null";
      };
    };
  };
}
