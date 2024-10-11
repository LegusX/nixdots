{
  pkgs,
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    outputs.nixosModules.gifWallpaper
  ];

  networking.hostName = "loganthinkbook";

  boot.loader.systemd-boot.enable = true;
  services.logind.lidSwitch = "hybrid-sleep";

  users.users = {
    logan = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "audio"];
    };
    becca = {
      isNormalUser = true;
    };
  };

  # services.gifWallpaper = {
  #   enable = true;
  #   dir = ../../src/wallpapers;
  #   random = builtins.toString (builtins.getEnv "$RANDOM");
  # };

  xdg.autostart.enable = !config.services.xserver.desktopManager.gnome.enable;
  xdg.portal = {
    xdgOpenUsePortal = true;
    enable = !config.services.xserver.desktopManager.gnome.enable;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };
  programs.dconf.enable = true;

  # stylix.enable = true;
  # stylix.image = config.services.gifWallpaper.png;

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      logan = import ../../home-manager/logan.nix;
      becca = import ../../home-manager/becca.nix;
    };
  };

  programs.zsh.enable = true;
}
