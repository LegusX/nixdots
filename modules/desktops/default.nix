{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hyprland
    ./flatpak.nix
    ./gnome
    ./sway
    ./niri
  ];

  hyprland.enable = lib.mkDefault false;
  desktops.gnome.enable = lib.mkDefault false;
  desktops.sway.enable = lib.mkDefault true;
  desktops.niri.enable = lib.mkDefault true;

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
  services.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    unstable.firefox
    librewolf
    qbittorrent
    signal-desktop
    kicad
    pwvucontrol
    calibre
    wlsunset
  ];

  programs.thunderbird = {
    # enable = true;
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
          "inode/directory" = "yazi.desktop";
        };
      };
      home.sessionVariables = {
        EDITOR = lib.mkForce "${lib.getExe pkgs.helix}";
        VISUAL = lib.mkForce "${lib.getExe pkgs.ghostty} -e ${lib.getExe pkgs.helix}";
        BROWSER = lib.mkForce "${lib.getExe pkgs.firefox}";
        TERMINAL = lib.mkForce "${lib.getExe pkgs.ghostty}";
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
      #   profiles.default = {
      #     "csharp.toolsDotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
      #     "dotnetAcquisitionExtension.sharedExistingDotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
      #     "dotnetAcquisitionExtension.existingDotnetPath" = [
      #       {
      #         "extensionId" = "ms-dotnettools.csharp";
      #         "path" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
      #       }
      #       {
      #         "extensionId" = "ms-dotnettools.csdevkit";
      #         "path" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
      #       }
      #       {
      #         "extensionId" = "woberg.godot-dotnet-tools";
      #         "path" = "${pkgs.dotnet-sdk_8}/bin/dotnet"; # Godot-Mono uses DotNet8 version.
      #       }
      #     ];
      #     "godotTools.lsp.serverPort" = 6005; # port should match your Godot configuration
      #     "omnisharp" = { # OminiSharp is a custom LSP for C#
      #       "path" = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
      #       "sdkPath" = "${pkgs.dotnet-sdk_9}";
      #       "dotnetPath" = "${pkgs.dotnet-sdk_9}/bin/dotnet";
      #     };
      #   };
      #   extensions = with pkgs.vscode-extensions; [
      #     geequlim.godot-tools # For Godot GDScript support
      #     woberg.godot-dotnet-tools # For Godot C# support
      #     ms-dotnettools.csdevkit
      #     ms-dotnettools.csharp
      #     ms-dotnettools.vscode-dotnet-runtime
      #   ];
      };
      programs.yazi = {
        enable = true;
        flavors = {
          ashen = inputs.ashen + "/ashen.yazi";
        };
        theme = {
          flavor = {
            dark = "ashen";
            light = "ashen";
          };
        };
        enableZshIntegration = true;
      };
    }
  ];
}
