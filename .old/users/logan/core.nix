# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./theme.nix
    ../../shared/home-manager/dev.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  programs.helix = {
    defaultEditor = true;
    enable = true;
    settings = {
      theme = "ayu_dark";
      editor = {
        bufferline = "multiple";
      };
      keys.normal = {
        space.w = ":w";
        space.q = ":q";
      };
    };
    themes = {
      base16 = builtins.fromTOML (builtins.readFile (osConfig.scheme inputs.theme-helix));
    };
  };

  home = {
    username = "logan";
    homeDirectory = "/home/logan";
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Logan Henrie";
    userEmail = "loghenrie@gmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
