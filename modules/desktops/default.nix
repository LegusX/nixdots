{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland
    ./flatpak.nix
    ./gnome
    ./sway
  ];

  hyprland.enable = lib.mkDefault false;
  desktops.gnome.enable = lib.mkDefault false;
  desktops.sway.enable = lib.mkDefault true;

  # Networking
  networking.networkmanager.enable = true;
  networking.resolvconf.dnsExtensionMechanism = false;
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };


  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    unstable.firefox
    librewolf
    qbittorrent
    signal-desktop
  ];

  programs.thunderbird = {
    enable = true;
    # profiles = {
    #   default = {
    #     isDefault = true;
    #   };
    # };
  };

  home-manager.sharedModules = [
    {
      home.packages = with pkgs; [
        obsidian
        spotify
        kanagawa-gtk-theme
        kanagawa-icon-theme
        chromium
        libreoffice
        # (discord.override { nss = nss_latest; })
        (pkgs.writeShellScriptBin "discord" ''
          exec ${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland
        '')
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
      };
      home.sessionVariables = {
        EDITOR = lib.mkForce "${lib.getExe pkgs.helix}";
        BROWSER = lib.mkForce "${lib.getExe pkgs.firefox}";
        TERMINAL = lib.mkForce "${lib.getExe pkgs.alacritty}";
      };
      programs.vscode = {
        enable = true;
        package = pkgs.vscode.fhsWithPackages (ps: with ps; [ 
          rustup 
          zlib 
          openssl.dev 
          pkg-config 
          nixd
        ]);
      };
    }
  ];
}
