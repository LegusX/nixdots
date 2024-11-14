{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  # Networking
  networking.networkmanager.enable = true;
  networking.resolvconf.dnsExtensionMechanism = false;

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
}
