{
  outputs,
  pkgs,
  lib,
  config,
  inputs,
  ...
}:let
  gamescope-git = pkgs.callPackage ./gamescope.nix { };

  ## all garbage
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
    # inputs.jovian.nixosModules.default
  ];

  options = {
    games.enable = lib.mkEnableOption "Enable games module";
    # games.tft.enable = lib.mkEnableOption = "Enable waydroid for TFT";
  };

  config = lib.mkIf config.games.enable {

    nixpkgs.overlays = [
    # Try to force gamescope-session to start on DisplayPort2
    (final: prev: {
      gamescope-session = prev.gamescope-session.overrideAttrs (_: {
          prePatch = ''
            sed -i "s/-O '\*',eDP-1/-O DP-2/" gamescope-session
          '';
      });
    })
];
    
    # jovian = {
    #   steam.enable = true;
    #   steamos.useSteamOSConfig = false;
    #   hardware.has.amd.gpu = true;
    # };
    
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

    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };
    # Hack to add -steamos3 to steam arguments
    # services.displayManager.sessionPackages = [ gamescopeSessionFile ];

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
          # graalvmPackages.graalvm-ce
        ];
      })
      limo
    ];

    services.sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
      settings = {
        capture = "kms";
      };
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "4k steam";
            prep-cmd = [
              {
                do = "sudo -u logan setsid /home/logan/.config/nixos-config/src/sunshine.sh start";
                undo = "sudo -u logan setsid /home/logan/.config/nixos-config/src/sunshine.sh stop";
              }
            ];
            # detached = [
            #   "sleep 10 && sudo -u logan setsid steam steam://open/bigpicture"
            # ];
            image-path = "steam.png";
            cmd = "sudo -u logan WAYLAND_DISPLAY=wayland-1 XDG_RUNTIME_DIR=/run/user/1000 gamescope -e -W 3840 -H 2160 --fullscreen --expose-wayland -- steam -gamepadui";
          }
        ];
      };
    };

    # Virtual display for streaming sunshine
    boot.kernelParams = ["video=DP-1:3840x2160R@60D"];
    hardware.display.edid.packages = [
      (pkgs.runCommand "edid-custom" { } ''
                  mkdir -p $out/lib/firmware/edid
                  cp ${../../src/custom1.bin} $out/lib/firmware/edid/custom1.bin
      '')
    ];
    hardware.display.outputs."DP-1".edid = "custom1.bin";

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
