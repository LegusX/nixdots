{
  pkgs,
  config,
  osConfig,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.default
    inputs.niri.homeModules.niri
  ];
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";

  programs.niri = {
    enable = true;
    # package = null;
    settings = {
      spawn-at-startup = [
      {
        command = [
          "${pkgs.systemd}/bin/systemctl"
          "--user"
          "import-environment"
          "PATH"
        ];
      }
      {
        command = [
          "${pkgs.dbus}/bin/dbus-update-activation-environment"
          "--systemd"
          "--all"
        ];
      }
      {
        command = [
          "${pkgs.systemd}/bin/systemctl"
          "--user"
          "restart"
          "xdg-desktop-portal.service"
        ];
      }
      {
        # udiskie doesn't specify a meta.mainprogram or whatever its called 
        command = [
          "${pkgs.udiskie}/bin/udiskie"
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.xwayland-satellite}"
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.swaynotificationcenter}"
        ];
      }
      {
        command = [
          "${pkgs.swww}/bin/swww-daemon"
        ];
      }
      {
        command = [
          "${pkgs.wl-clipboard}/bin/wl-paste"
          "--type"
          "text"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "${pkgs.wl-clipboard}/bin/wl-paste"
          "--type"
          "image"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.dconf}"
          "write"
          "/org/gnome/desktop/interface/gtk-theme"
          "\"'Colloid-Orange-Dark'\""
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.dconf}"
          "write"
          "/org/gnome/desktop/interface/icon-theme"
          "\"'Colloid-Orange-Dark'\""
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.dconf}"
          "write"
          "/org/gnome/desktop/interface/document-font-name"
          "\"'Roboto'\""
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.dconf}"
          "write"
          "/org/gnome/desktop/interface/font-name"
          "\"'Roboto'\""
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.dconf}"
          "write"
          "/org/gnome/desktop/interface/monospace-font-name"
          "\"'RobotoMono Nerd Font'\""
        ];
      }
      ];
      
      environment = {
        "NIXOS_OZONE_WL" = "1";#C0FFEE
        "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
        "DISPLAY" = ":0";
      };

      outputs = {
        "DP-1" = {
          mode.width = 2560;
          mode.height = 1440;
          mode.refresh = 74.87;
          position.x = 0;
          position.y = 0;
        };
        "DP-2" = {
          enable = false;
        };
        "HDMI-A-1" = {
          mode.width = 1920;
          mode.height = 1080;
          mode.refresh = 60.0;
          position.x = 2560;
          position.y = 0;
        };
      };

      input = {
        keyboard.xkb.options = "caps:super";
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = true;
      };

      cursor.size = 20;
      cursor.theme = "Vimix-cursors";
      screenshot-path = null;
      prefer-no-csd = true;

      binds = with config.lib.niri.actions; let
        sh = spawn "sh" "-c";
      in
        lib.attrsets.mergeAttrsList [
          {
            "Mod+Q".action = spawn "ghostty";
            "Mod+C".action = close-window;
            "Mod+M".action = quit {skip-confirmation = true;};
            "Mod+E".action = spawn "ghostty" "-e" "yazi";
            "Mod+V".action = toggle-window-floating;
            "Mod+Space".action = spawn "walker";
          # "Mod+L".action = spawn "hyprlock";
            "Mod+Shift+S".action = screenshot;
            "Mod+Shift+F".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | swappy -f -";
            "Mod+F".action = fullscreen-window;
            "Mod+W".action = switch-preset-column-width;

            "Mod+WheelScrollDown" = {
              action = focus-workspace-down;
              cooldown-ms = 250;
            };
            "Mod+WheelScrollUp" = {
              action = focus-workspace-up;
              cooldown-ms = 250;
            };

            "Mod+MouseBack".action = focus-column-right;
            "Mod+MouseForward".action = focus-column-left;
            "Mod+Shift+MouseBack".action = focus-column-last;
            "Mod+Shift+MouseForward".action = focus-column-first;
                   
            # "xf86monbrightnessup" exec, /nix/store/898cjdq7lg8vfg7yqgk3hv3h3220lfr6-swayosd-0.1.0/bin/swayosd-client --brightness raise
            # "xf86monbrightnessdown" exec, /nix/store/898cjdq7lg8vfg7yqgk3hv3h3220lfr6-swayosd-0.1.0/bin/swayosd-client --brightness lower
            # "xf86audioraisevolume" exec, /nix/store/898cjdq7lg8vfg7yqgk3hv3h3220lfr6-swayosd-0.1.0/bin/swayosd-client --output-volume raise
            # "xf86audiolowervolume" exec, /nix/store/898cjdq7lg8vfg7yqgk3hv3h3220lfr6-swayosd-0.1.0/bin/swayosd-client --output-volume lower
            # "xf86audiomute" = sh "${pkgs.swayosd}/bin/swayosd-client" "--output-volume" "mute-toggle"
          }
          # (builtins.listToAttrs (with config.lib.niri.actions; map (n:{
          #   name = "Mod+Shift+${toString n}";
          #   value = {
          #     action = move-window-to-workspace "workspace" (n+1);
          #   };
          # }) (lib.lists.range 1 9)))
          # (bindsxx {
          #   suffixes = builtins.listToAttrs (map (n: {
          #     name = toString n;
          #     value = ["workspace" (n + 1)]; # workspace 1 is empty; workspace 2 is the logical first.
          #   }) (range 1 9));
          #   prefixes."${Mod}" = "focus";
          #   prefixes."${Mod}+Ctrl" = "move-window-to";
          # })
        ];

        window-rules = [
          {
            matches = [
              {
                app-id = "steam";
                title="r#\"^notificationtoasts_\d+_desktop$\"#";
              }
            ];
            default-floating-position = {
              x = 10;
              y = 10;
              relative-to = "bottom-right";
            };
          }
          {
            matches = [
              {app-id = "steam_app_72850";}
            ];
            default-column-width = {
              proportion = 1.0;
            };
          }
          {
            clip-to-geometry = true;
            geometry-corner-radius = let radius = 12.0;
            in {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
          }
        ];

        layout = {
          preset-column-widths = [
            {proportion = 1. / 3.;}
            {proportion = 1. / 2.;}
            {proportion = 2. / 3.;}
            {proportion = 1.;}
          ];
          always-center-single-column = true;
          default-column-width.proportion = 1. / 3.;

          focus-ring = with osConfig.scheme.withHashtag; {
            width = 4;
            active.color = base08;
          };
        };
    };
  };

  home.packages = with pkgs; [
    cliphist
    waybar
    udiskie
    swaynotificationcenter
    udiskie
    wl-clipboard
    # alacritty
  ];

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
    stylePath = "${config.xdg.configHome}/swayosd/style.css";
  };

  # programs.gauntlet = {xxx
  #   enable = true;
  #   service.enable = true;
  # };
  programs.walker = {
    enable = true;
    # runAsService = true;

    config = {
      websearch.prefix = "?";
      # AppLaunchPrefix = "uwsm app --";
    };
  };

  xdg.configFile."sway/config" = {
    # source = config.lib.file.mk OutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/hyprland.conf";
    source = ../../../config/sway.conf;
  };
  # xdg.configFile."test/test".text = "test";
}
