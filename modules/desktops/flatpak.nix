{lib,...}:{    
  services.flatpak = {
    enable = true;
    
    update.auto = {
      enable = true;
    };
    
    remotes = lib.mkOptionDefault [{
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }];
    
    # packages = [
    #   { appId = "com.discordapp.DiscordCanary"; origin = "flathub-beta"; }
    #   "com.discordapp.Discord"
    # ];

    overrides = {
      global = {
        Context.sockets = ["wayland" "!x11" "!fallback-x11"];

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";

          # Force correct theme for some GTK apps
          GTK_THEME = "Adwaita:dark";
        };
      };
      "com.discordapp.DiscordCanary".Context = {
        filesystems = ["home"];
      };
    };
  };
}
