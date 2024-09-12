{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  services.logind.lidSwitch = "hybrid-sleep";
  #imports = [
  #  ./configuration.nix
  #  ./hyprland.nix
  #];

  environment.systemPackages = with inputs; [
    # nautilus
  ];
}
