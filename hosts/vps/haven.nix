{inputs,outputs,pkgs,config,lib,...}:
{

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers = {
    containers.haven = {
      autoStart = true;
      image = "ghcr.io/ancsemi/haven:latest";
      ports = ["3000:3000"];
      pull = "newer";
      environmentFiles = [
        config.sops.templates."haven.env".path
      ];
    };
  };

  services.nginx.virtualHosts."haven.legusx.dev" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
    };
  };

  sops.secrets.haven-coturn = {
    owner = "turnserver";
    group = "turnserver";
  };
  sops.templates."haven.env".content = ''
    TURN_URL=turn:turn.legusx.dev
    TURN_SECRET=${config.sops.placeholder.haven-coturn}
  '';

  services.nginx.virtualHosts."turn.legusx.dev" = {
    enableACME = true;
    forceSSL = false; # Not needed for TURN
  };

  services.coturn = {
    enable = true;
    realm = "turn.legusx.dev";

    no-cli = true;

    extraConfig = "
        fingerprint
        no-tlsv1
        no-tlsv1_1
      ";

    listening-port = 3478;
    tls-listening-port = 5349;

    cert = "/var/lib/acme/turn.legusx.dev/fullchain.pem";
    pkey = "/var/lib/acme/turn.legusx.dev/key.pem";

    min-port = 49152;
    max-port = 49999;
    
    use-auth-secret = true;
    static-auth-secret-file = config.sops.secrets.haven-coturn.path;
  };

  networking.firewall.allowedUDPPortRanges = [
    {
      from = 49152;
      to = 49999;
    }
  ];
  networking.firewall.allowedUDPPorts = [ 3478 ];
  networking.firewall.allowedTCPPorts = [ 3478 5349];

  users.users.turnserver.extraGroups = ["acme"]; # Ensure coturn can read acme cert
}
