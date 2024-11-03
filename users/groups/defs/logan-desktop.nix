{
  lib,
  ...
}:
{
  imports = [./logan.nix];
  home-manager.users.logan = lib.mkForce import ../../logan/desktop.nix;
}
