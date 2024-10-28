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
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  networking.hostName = "oraclevps";
  users.users = {
    logan = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel"];
      initialPassword = "pleasepasswdnow";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDg9USVFHk+6yHSutbFAa0KOTz71zZikc5TmGY3vnPic logan@nixos"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDagHYo50nLw9/0VtVI2WbjOz6oz7dM+D6YMsR8nHXKqfhErQBleuvcwnnhLUr3LjsyF3RVtYUf+WYSFnwz+0ZBJNtMdqLJg0OsPXsM1ugbZlx4ZVNb1uMm2vZ1cer0DbDqAQsWwVsB3Z+E5VbUmcpRNFFbRhR9bd5/b3qPV+wHoGriAIkcFHcJ1HKTksHcFh27MYPqBkNcOkPjAPk1Vtr53v/4JK7Q7Z6CyJagw/axuNEmGlXDDvfN8vPfwxsR47VOjjqk9l1rhLODl+XLZKXtTbRr3+mKcVirBhMX0fPZ+FxVVraH741tlVuWrlyuECfPiVRLWo+TH/P4asxZxpnp9exXJ/miofPRJemtwm076MJm7Tw6EVlJynfY34iaA4ZWJCPOQCSIj4krzAcTf1OhxGsmlwoNpVecYoUVYaLZ6eiAhb1YGbm15vGwpf3IW1vPF+v09OiR+E5XbwOTCxY6Kk5XEgjqAjRENdvK/qP70XcjLt+5zThFh9FDS8e+Ry0= logan@ryzen-shine"
      ];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      logan = import ../../home-manager/logan.nix;
    };
  };

  programs.zsh.enable = true;

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
}
