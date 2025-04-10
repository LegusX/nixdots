{
  pkgs,
  config,
  osConfig,
  inputs,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.default
  ];
  home.sessionVariables.NIXOS_OZONE_WL = "1";
  home.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = "wayland";

  programs.niri = {
    enable = true;
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
          "${pkgs.systemd}/bin/systemctl"
          "--user"
          "restart"
          "xdg-desktop-portal.service"
        ];
      }
      {
        command = [
          "${lib.getExe pkgs.udiskie}"
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
        "NIXOS_OZONE_WL" = 1;
        "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
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
          mode.refresh = 60;
          position.x = 2560;
          position.y = 0;
        };
      };

      input.keyboard.xkb.options = "caps:super";
    }
  }

  home.packages = with pkgs; [
    cliphist
    waybar
    udiskie
    swaynotificationcenter
    udiskie
    wl-clipboard
    alacritty
  ];

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
    stylePath = "${config.xdg.configHome}/swayosd/style.css";
  };

  programs.walker = {
    # enable = true;
    runAsService = true;

    config = {
      websearch.prefix = "?";
      AppLaunchPrefix = "uwsm app --";
    };
  };

  xdg.configFile."sway/config" = {
    # source = config.lib.file.mk OutOfStoreSymlink "${config.home.homeDirectory}/.nixos/config/hyprland.conf";
    source = ../../../config/sway.conf;
  };
}
