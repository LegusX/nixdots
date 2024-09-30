{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../games.nix
  ];

  boot = {
    plymouth = {
      enable = true;
      theme = "bgrt";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["hud_3"];
        })
      ];
    };
    initrd.systemd.enable = true;
    initrd.kernelModules = ["i915"];
    loader.systemd-boot = {
      editor = false;
      enable = true;
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "plymouth.use-simpledrm"
      #"logo.nologo"
      #"video=efifb:nobgrt"
      #"fbcon=nodefer"
    ];
    loader.timeout = 0;
  };

  services.logind.lidSwitch = "hybrid-sleep";

  networking.hostName = "beccabook";

  users.users = {
    logan = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "audio"];
    };
    becca = {
      isNormalUser = true;
      initialPassword = "beccababe";
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      logan = import ../../home-manager/logan.nix;
      becca = import ../../home-manager/becca.nix;
    };
  };
}
