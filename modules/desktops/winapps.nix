{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.winapps.packages."${pkgs.system}".winapps
    inputs.winapps.packages."${pkgs.system}".winapps-launcher
    pkgs.podman-compose
  ];

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
