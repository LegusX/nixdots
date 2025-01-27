{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  boot = {
    extraModprobeConfig = ''
      options rtw88_pci disable_aspm=1
    '';
    plymouth = {
      enable = true;
      theme = "hud_3";
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
  time.timeZone = "America/New_York";
}
