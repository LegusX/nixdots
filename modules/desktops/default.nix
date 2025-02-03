{
  pkgs,
  lib,
  ...
}: 
{
  imports = [
    ./hyprland
    # ./gnome
  ];

  hyprland.enable = lib.mkDefault true;

  # Networking
  networking.networkmanager.enable = true;
  networking.resolvconf.dnsExtensionMechanism = false;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    firefox
    librewolf
  ];

  programs.thunderbird = {
    enable = true;
    # profiles = {
    #   default = {
    #     isDefault = true;
    #   };
    # };
  };

  home-manager.sharedModules = [
    {
    home.packages = with pkgs; [
      obsidian
      vscode-fhs
      spotify
      kanagawa-gtk-theme
      kanagawa-icon-theme
      chromium
      libreoffice
      # discord
    ];
    
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
    home.sessionVariables = {
        EDITOR = "${lib.getExe pkgs.helix}";
        BROWSER = "${lib.getExe pkgs.firefox}";
        TERMINAL = "${lib.getExe pkgs.alacritty}";
    };
    }
  ];
}
