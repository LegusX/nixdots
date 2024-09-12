{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  boot.loader.systemd-boot.enable = true;

  #imports = [
  #  ./configuration.nix
  #  ./hyprland.nix
  #];

  environment.systemPackages = with inputs; [
    # nautilus
  ];
}
