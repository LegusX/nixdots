{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: 
  let
    inherit (inputs.nix-minecraft.lib) collectFilesAt;
    modpack = pkgs.fetchModrinthModpack {
      # url = "https://cdn.modrinth.com/data/x308hQIU/versions/q4P5coPI/Isabel%27s%20Aeroscapes-1.0.7.mrpack";
      src = ../../src/minecraft/Leaguecraft.mrpack;
      packHash = "sha256-gNsvYdN5XqbuPaRe8323kb3MwdhvZfk0Aha6Dd7/HKg=";
      side = "server";
    };
    mcVersion = modpack.manifest.dependencies.minecraft;
    neoforgeVersion = modpack.manifest.dependencies.neoforge;
    serverVersion = lib.replaceStrings [ "." ] [ "_" ] "neoforge-${mcVersion}";
  in
{
  options = {
    services.minecraft.ryzenshine.enable = lib.mkEnableOption "Enable ryzenshine minecraft server";
    services.minecraft.homestead.enable = lib.mkEnableOption "Enable homestead minecraft server";
    services.minecraft.aero.enable = lib.mkEnableOption  "Enable aero minecraft server";
    services.minecraft.leaguecraft.enable = lib.mkEnableOption "Enable leaguecraft server";
  };

  config = {
    users.users.minecraft = {
      isSystemUser = true;
      group = "minecraft";
    };
    users.groups.minecraft = {};
    networking.firewall.allowedTCPPorts = [25565 25566];

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
    systemd.services.minecraft-homestead = lib.mkIf config.services.minecraft.homestead.enable {
      enable = true;
      wants = ["network.target"];
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      description = "Homestead Minecraft server";
      environment = {
        JAVA = "${pkgs.jdk21}/bin/java";
      };
      serviceConfig = {
        User = "minecraft";
        WorkingDirectory = "/opt/minecraft/homestead";
        ExecStart = "${pkgs.jdk21}/bin/java -Xmx4G -jar server.jar nogui";

        Restart = "always";
        RestartSec = "30";

        StandardInput = "null";
      };
    };
    systemd.services.minecraft-family = {
      enable = false;
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
    systemd.services.minecraft-aero = lib.mkIf config.services.minecraft.aero.enable {
      enable = true;
      wants = ["network.target"];
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      description = "Aero Minecraft server";
      environment = {
        JAVA = "${pkgs.jdk21}/bin/java";
      };
      serviceConfig = {
        User = "minecraft";
        WorkingDirectory = "/opt/minecraft/aero";
        ExecStart = "${pkgs.bash}/bin/bash run.sh";

        Restart = "always";
        RestartSec = "30";

        StandardInput = "null";
      };
    };
    
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
  services.minecraft-servers.eula = true;
  services.minecraft-servers.enable = true;
  services.minecraft-servers.servers.leaguecraft = {
    enable = config.services.minecraft.leaguecraft.enable;
    autoStart = true;
    enableReload = true;
    openFirewall = true;
    
    package = pkgs.neoforgeServers.${serverVersion};
    symlinks = collectFilesAt modpack "mods" // collectFilesAt ../../src/minecraft "mods";
    files = {
      "config" = "${modpack}/config";
    };

    operators = {
      "LegusX" = "b128a779-618e-4909-bb98-3ef4b1153823";
    };

    serverProperties = {
      allow-flight = true;
      white-list = true;
      difficulty = "hard";
      gamemode = "survival";
      max-players = 10;
      motd = "Leaguecraft";
      level-seed = "league of minecraft";
      spawn-protection = 0;
    };

    jvmOpts = "-Xms12G -Xmx12G -XX:+UseZGC";
  };
  };
}
