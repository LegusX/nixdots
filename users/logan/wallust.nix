{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    unstable.wallust
  ];

  home.file."${config.xdg.configHome}/wallust/wallust.toml" = {
    text = ''
      backend = "kmeans"
      color_space = "lch"
      palette = "dark16"
      check_contrast = false

      [templates]
      base = { template = 'base16', target = '~/.config/nixos-config/src/base16_theme.yaml'}
    '';
  };

  home.file."${config.xdg.configHome}/wallust/templates/base16" = {
    text = ''
      scheme: "Wallust Generated"
      author: "Wallust"
      name: "Wallust Theme"
      base00: "{{color0 | strip}}"
      base01: "{{color1 | strip}}"
      base02: "{{color2 | strip}}"
      base03: "{{color3 | strip}}"
      base04: "{{color4 | strip}}"
      base05: "{{color5 | strip}}"
      base06: "{{color6 | strip}}"
      base07: "{{color7 | strip}}"
      base08: "{{color8 | strip}}"
      base09: "{{color9 | strip}}"
      base0A: "{{color10 | strip}}"
      base0B: "{{color11 | strip}}"
      base0C: "{{color12 | strip}}"
      base0D: "{{color13 | strip}}"
      base0E: "{{color14 | strip}}"
      base0F: "{{color15 | strip}}"
    '';
  };
}