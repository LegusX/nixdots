{
  config,
  pkgs,
  inputs,
  outputs,
  modulesPath,
  lib,
  ...
}: {
    imports = [inputs.home-manager.nixosModules.home-manager
      ../users/logan.nix
      ../modules/cli/default.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    time.timeZone = "America/New_York";

    networking.hostName = "meshy";

    services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1oHkRdSwpahozBf0cr1huRkipnnghPJnmv+5gmrQGB logan@ryzenshine"
    ];
    
  }
