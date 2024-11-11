{lib, ...}: {
  imports = [./logan.nix];
  home-manager.users.logan = import ../../logan/desktop.nix;
}
