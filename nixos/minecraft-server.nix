{
  pkgs,
  config,
  ...
}:
let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/LegusX/nixdots/355e655936f42b8d4b29ca13205f406813135e06/src/minecraft/family/pack.toml";
    packHash = "sha256-0hk8144ib1664big6j4rv1mrfin8ig7k7hj54nwijapqafh089jd";
  };
  mcVersion = modpack.manifest.versions.minecraft;
  fabricVersion = modpack.manifest.versions.fabric;
  serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
in
{
  services.minecraft-servers.servers.family = {
    enable = true;
    eula=true;
    package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
    symlinks = {
      "mods" = "${modpack}/mods";
    };
    openFirewall = true;
    autostart = true;
    serverProperties = {
      difficulty = 3;
      gamemode = 1;
      motd = "Henrie Family Minecraft Server";
    };
    jvmopts = "-Xmx8192M";
  };
  networking.firewall = {
    allowedTCPPorts = [19132];
    allowedUDPPorts = [19132];
  };
}
