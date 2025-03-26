{lib, ...}: {
  imports = [
    ./vpn.nix
    ./cli
    ./desktops
    ./games
  ];
  vpn.enable = lib.mkDefault true;
  # hyprland.enable = lib.mkDefault true;
  games.enable = lib.mkDefault true;
}
