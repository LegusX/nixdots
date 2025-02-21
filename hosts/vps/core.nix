{
  config,
  pkgs,
  inputs,
  outputs,
  modulesPath,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./mealie.nix
    ./nextcloud.nix 
    ./actual.nix
    ./matrix.nix
    ../../users
    ../../modules/cli
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  networking.hostName = "oraclevps";

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];

  services.nginx.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "logan@legusx.dev";
  };

  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1oHkRdSwpahozBf0cr1huRkipnnghPJnmv+5gmrQGB logan@ryzenshine"
  ];
  # services.cloudflared = {
  #   enable = true;
  #   tunnels = {
  #     "2165eb5d-35f7-4986-8fb7-59a51c18efa0" = {
  #       credentialsFile = "${sops.secrets.cloudflare.path}";
  #       default = "http_status:404";
  #     };
  #   };
  # };

  # Disk formatting
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              end = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "bcachefs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_scsi"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
  boot.tmp.useTmpfs = false;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
  system.stateVersion = "24.11";
}
