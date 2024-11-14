{
  pkgs,
  config,
  osConfig,
  ...
}: {
  imports = [
  ];
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    cliphist
    waybar
    udiskie
    swaynotificationcenter
    udiskie
    wl-clipboard
    alacritty
  ];

  programs.hyprlock = with osConfig.scheme; {
    enable = true;
    settings = {
      background = [
        {
          path = "~/.config/nixos-config/src/wallpaper.png";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.3;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        }
      ];

      general = {
        no_fade_in = true;
        no_fade_out = false;
        hide_cursor = true;
        grace = 5;
      };

      input-field = {
        size = "200, 40";
        outline_thickness = 1;
        outer_color = "rgb(${base04})";
        inner_color = "rgb(${base00})";
        rounding = 5;
        fade_on_empty = false;
        dots_center = false;
        dots_fade_time = 50;
        font_color = "rgb(${base04})";
        position = "0, -10%";
        placeholder_text = "";
      };

      label = {
        text = "cmd[update:1000] echo \"$(date +\"%0I:%M\")\"";
        position = "0, 30%";
        halign = "center";
        valign = "center";
        font_size = 90;
        font_family = "RobotoMono Nerd Font";
        color = "rgb(${base0C})";
        z-index = 1;
      };

      shape = [
        {
          size = "400, 400";
          border_size = 5;
          border_color = "rgb(${base0C})";
          # color = "rgb(${base0C})";
          position = "-50, 0";
          halign = "center";
          valign = "center";
          rotate = 45;
        }
        {
          size = "400, 400";
          border_size = 5;
          border_color = "rgb(${base0C})";
          # color = "rgb(${base0C})";
          position = "50, 0";
          halign = "center";
          valign = "center";
          rotate = 45;
        }
        {
          size = "400, 400";
          border_size = 5;
          border_color = "rgb(${base0C})";
          position = "0, -50";
          halign = "center";
          valign = "center";
          rotate = 45;
        }
        {
          size = "400, 400";
          border_size = 5;
          border_color = "rgb(${base0C})";
          position = "0, 50";
          halign = "center";
          valign = "center";
          rotate = 45;
        }
      ];
    };
  };

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "sleep 1 && hyprctl dispatch dpms on";
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = with osConfig.scheme; {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "swayosd-server & waybar & udiskie & swaync & swww-daemon & sleep 1 && sww img ~/.config/nixos-config/src/wallpaper.gif --transition-type wipe &"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      input = {
        kb_layout = "us";
        kb_options = "caps:super";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
        };
        sensitivity = 0;
        numlock_by_default = true;
      };

      general = {
        gaps_in = 5;
        gaps_out = "5,10,10,10";
        border_size = 3;
        bezier = "linear, 0.0, 0.0, 1.0, 1.0";

        layout = "dwindle";
        "col.active_border" = "rgb(${base0C})";
        "col.inactive_border" = "rgba(00000000)";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          brightness = 0.75;
          noise = 0.05;
        };
        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
      };

      animations = {
        enabled = "yes";

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      gestures = {
        workspace_swipe = "off";
      };

      misc = {
        focus_on_activate = true;
      };

      "$mainMod" = "SUPER";

      bind =
        [
          "$mainMod, Q, exec, alacritty"
          "$mainMod, C, killactive"
          "$mainMod, M, exit"
          "$mainMod, E, exec, nautilus"
          "$mainMod, V, togglefloating"
          "$mainMod, SPACE, exec, pkill wofi || wofi --show drun"
          "$mainMod, L, exec, hyprlock"
          "SUPER_SHIFT, S, exec, hyprshot -m region --clipboard-only"
          ", xf86monbrightnessup, exec, ${config.services.swayosd.package}/bin/swayosd-client --brightness raise"
          ", xf86monbrightnessdown, exec, ${config.services.swayosd.package}/bin/swayosd-client --brightness lower"
          ", xf86audioraisevolume, exec, ${config.services.swayosd.package}/bin/swayosd-client --output-volume raise"
          ", xf86audiolowervolume, exec, ${config.services.swayosd.package}/bin/swayosd-client --output-volume lower"
          ", xf86audiomute, exec, ${config.services.swayosd.package}/bin/swayosd-client --output-volume mute-toggle"
        ]
        ++ (
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mainMod, code:1${toString i}, workspace, ${toString ws}"
                "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      #blurls = "waybar";
    };
  };
}
