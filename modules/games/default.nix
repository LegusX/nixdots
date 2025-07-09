{
  outputs,
  pkgs,
  lib,
  config,
  ...
}:let
  cfg = config.programs.steam;
  gamescopeCfg = config.programs.gamescope;

  extraCompatPaths = lib.makeSearchPathOutput "steamcompattool" "" cfg.extraCompatPackages;

  steam-gamescope = let
    exports = builtins.attrValues (builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env);
  in
    pkgs.writeShellScriptBin "steam-gamescope" ''
      ${builtins.concatStringsSep "\n" exports}
      ${pkgs.gamescope}/bin/gamescope --steam ${builtins.toString cfg.gamescopeSession.args} -- steam -tenfoot -pipewire-dmabuf -steamos3
    '';

  gamescopeSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
      [Desktop Entry]
      Name=Steam
      Comment=A digital distribution platform
      Exec=${pkgs.gamescope}/bin/gamescope --steam ${builtins.toString cfg.gamescopeSession.args} -- steam -tenfoot -pipewire-dmabuf -steamos3
      Type=Application
    '').overrideAttrs (_: { passthru.providedSessions = [ "steam" ]; });
in {
  imports = [
    ./minecraft.nix
    ./df.nix
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
      extraCompatPackages = [pkgs.proton-ge-bin];
      gamescopeSession = {
        # enable = true;
        args = ["-O" "DP-2" "-W" "3840" "-H" "2160"];
        env = {
          "ENABLE_HDR_WSI"="1";
          "DXVK_HDR"="1";
        };
      };
    };

    # Hack to add -steamos3 to steam arguments
    services.displayManager.sessionPackages = [ gamescopeSessionFile ];

    environment.systemPackages = with pkgs; [
      # heroic
      protontricks
      lutris
      unstable.ryubing
      # torzu # DMCA takedown
      steam-rom-manager
      steamtinkerlaunch
      bottles
      (prismlauncher.override {
        # withWaylandGLFW = true;
        jdks = with pkgs; [
          jdk21
          graalvm-ce
        ];
      })
    ];

    # virtualisation.waydroid.enable = true;

    # Skyrim Modding NXM links
    # Only sorta works. Spawns a new MO2 window every time you open a link. Nothing breaks, just kinda annoying to have 5 windows open all the time.
    home-manager.sharedModules = [
      {
        xdg.desktopEntries.nxm-handler = {
          name = "Nexus Mods Link Handler";
          exec = "steam-run steamtinkerlaunch mo2 url %u";
          mimeType = ["x-scheme-handler/nxm"];
          noDisplay = false;
          type = "Application";
        };
        xdg.mimeApps.defaultApplications = {
          "x-scheme-handler/nxm" = "nxm-handler.desktop";
        };
      }
    ];
  };
}
