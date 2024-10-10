# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./hyprland.nix
    ./zsh.nix
    ./firefox.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
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
  home.packages = with pkgs; [
    obsidian
    vscode-fhs
  ];

  programs.helix = {
    defaultEditor = true;
    enable = true;
    settings = {
      theme = "base16_terminal";
      editor = {
        bufferline = "multiple";
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
      };
    };
  };

  home = {
    username = "logan";
    homeDirectory = "/home/logan";
  };

  stylix = {
    enable = true;
    autoEnable = false;
    polarity = "dark";
    opacity = {
      desktop = 0.3;
      terminal = 0.4;
      popups = 0.3;
    };
    targets = {
      avizo.enable = true;
      alacritty.enable = true;
      kitty.enable = true;
      btop.enable = true;
      dunst.enable = true;
      firefox.enable = true;
      gnome.enable = true;
      gtk.enable = true;
      helix.enable = false;
      hyprland.enable = true;
      # hyprpaper.enable = true;
      # kde.enable = true;
      swaylock.enable = true;
      # #wofi.enable = true;
    };

    fonts = {
      sansSerif = {
        package = pkgs.roboto;
        name = "Roboto";
      };
      serif = {
        package = pkgs.roboto;
        name = "Roboto";
      };
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["RobotoMono"];};
        name = "RobotoMono Nerd Font";
      };
      emoji = {
        package = pkgs.twitter-color-emoji;
        name = "Twitter Color Emoji";
      };
    };
    cursor = {
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
      size = 12;
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
