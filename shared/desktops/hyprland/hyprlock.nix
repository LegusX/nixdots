{
  osConfig,
  ...
}:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on && kill $(pidof hypridle) || true) && (pidof hypridle || hypridle)";
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

}
