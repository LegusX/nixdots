{
  pkgs,
  config,
  osConfig,
  inputs,
  ...
}: {
  imports = [
    ./hyprlock.nix
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

  home.file."${config.xdg.configHome}/swayosd/style.css" = {
    text = (builtins.readFile (osConfig.scheme inputs.theme-waybar)) + (builtins.readFile ../../../src/swayosd.css);
  };

  services.swayosd = {
    enable = true;
    topMargin = 0.9;
    stylePath = "${config.xdg.configHome}/swayosd/style.css";
  };

  wayland.windowManager.hyprland = with osConfig.scheme; {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "dbus-update-activation-environment --systemd --all"
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
        rounding = 2;
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
