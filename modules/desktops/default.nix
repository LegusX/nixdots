{
  pkgs,
  ...
}: 
{
  imports = [
    ./hyprland
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

  environment.systemPackages = withpkgs; [
    firefox
    librewolf
  ]

  programs.thunderbird = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
      };
    };
  };

  home-manager.sharedModules = [{home.packages = with pkgs; [
    obsidian
    vscode-fhs
    spotify
    kanagawa-gtk-theme
    kanagawa-icon-theme
    chromium
    libreoffice
    # discord
  ];}]
}