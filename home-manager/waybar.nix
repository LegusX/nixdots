{config, lib, pkgs, ...}:
let
  colorNames = [
    "base00"
    "base01"
    "base02"
    "base03"
    "base04"
    "base05"
    "base06"
    "base07"
    "base08"
    "base09"
    "base0A"
    "base0B"
    "base0C"
    "base0D"
    "base0E"
    "base0F"
  ];
  colors = config.lib.stylix.colors.withHashtag;
  defineColor = name: value: "@define-color ${name} ${value};";
  in
{
  programs.waybar = {
    enable = true;
        style = lib.strings.concatStringsSep "\n"
      (
        # Convert the colors attribute set to GTK color declarations
        builtins.map (color: defineColor color colors.${color}) colorNames
      )
    +
    # Append the main CSS file
    (builtins.readFile ../src/waybar.css)
    +
    # Use monospace font
    ''
      /* Font family injected by Nix */
      * {
        font-family: ${config.stylix.fonts.monospace.name};
        color: @base05;
        font-size:13px;
        min-height:0;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 10;
        margin-bottom = 0;
        margin-top = 0;

        modules-left = ["cpu" "memory" "network" "custom/spotify"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["tray" "pulseaudio" "backlight" "battery" "clock"];

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}&#8239;{capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["  " "  " "  " "  " "  "];
        };

        tray = {
          icon-size = 16;
          spacing = 6;
        };

        clock = {
          locale = "C";
          format = "  {:%I:%M %p}";
          format-alt = "  {:%a,%b %d}";
        };

        cpu = {
          format = "  &#8239;{usage}%";
          tooltip = false;
          on-click = "kitty -e 'btop'";
        };

        memory = {
          interval = 30;
          format = "  {used:0.2f}GB";
          max-length = 10;
          tooltip = false;
          warning = 70;
          on-click = "kitty -e 'btop'";
        };

        network = {
          interval = 2;
          format-wifi = "   {signalStrength}%";
          format-ethernet = "";
          format-linked = " {ipaddr}";
          format-disconnected = "   Disconnected";
          format-disabled = "";
          tooltip = false;
          max-length = 20;
          min-length = 6;
          format-alt = "{essid}";
        };

        backlight = {
          format = "{icon}&#8239;{percent}%";
          format-icons = ["" ""];
          on-scroll-down = "brightnessctl -c backlight set 1%-";
          on-scroll-up = "brightnessctl -c backlight set +1%";
        };

        pulseaudio = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{icon} {volume}% {format_source}";
          format-bluetooth-muted = " {format_source}";
          format-muted = " {format_source}";
          format-source = "  {volume}%";
          format-source-muted = "  ";
          format-icons = {
            headphone = "  ";
            hands-free = "  ";
            headset = "🎧  ";
            phone = "  ";
            portable = "  ";
            default = [" " " " "  "];
          };
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        # "custom/spotify" = {

        #}
      };
    };
  };
}
