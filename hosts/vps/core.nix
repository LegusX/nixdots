{
  config,
  pkgs,
  inputs,
  outputs,
  modulesPath,
  lib,
  ...
}:
  let
    inherit (inputs.nix-minecraft.lib) collectFilesAt;
    modpack = pkgs.fetchModrinthModpack {
      # url = "https://cdn.modrinth.com/data/x308hQIU/versions/q4P5coPI/Isabel%27s%20Aeroscapes-1.0.7.mrpack";
      src = ../../src/minecraft/Leaguecraft.mrpack;
      packHash = "sha256-gNsvYdN5XqbuPaRe8323kb3MwdhvZfk0Aha6Dd7/HKg=";
      side = "server";
    };
    mcVersion = modpack.manifest.dependencies.minecraft;
    neoforgeVersion = modpack.manifest.dependencies.neoforge;
    serverVersion = lib.replaceStrings [ "." ] [ "_" ] "neoforge-${mcVersion}";
  in
  {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./haven.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ../../users
    ../../modules/cli
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  networking.hostName = "oraclevps";

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];

  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
  services.minecraft-servers.eula = true;
  services.minecraft-servers.enable = true;
  services.minecraft-servers.servers.leaguecraft = {
    enable = true;
    autoStart = true;
    enableReload = true;
    openFirewall = true;
    
    package = pkgs.neoforgeServers.${serverVersion};
    symlinks = collectFilesAt modpack "mods";# // collectFilesAt ../../src/minecraft/lom "mods";
    files = {
      "config" = "${modpack}/config";
    };

    operators = {
      "LegusX" = "b128a779-618e-4909-bb98-3ef4b1153823";
    };

    serverProperties = {
      allow-flight = true;
      white-list = true;
      difficulty = "hard";
      gamemode = "survival";
      max-players = 10;
      motd = "Leaguecraft";
      level-seed = "league of minecraft";
      spawn-protection = 0;
    };

    jvmOpts = "-Xms12G -Xmx12G -XX:+UseZGC";
  };

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
