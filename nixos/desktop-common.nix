{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  # Networking
  networking.networkmanager.enable = true;

  # Sound
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  # Theming
  services.gifWallpaper = {
    enable = true;
    dir = ../src/wallpapers;
    random = builtins.toString (builtins.getEnv "$RANDOM");
  };

  stylix = {
    enable = true;
    autoEnable = false;
    image = config.services.gifWallpaper.png;
  };
}
