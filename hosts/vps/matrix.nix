{pkgs, inputs, ...}:
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/matrix/conduwuit.nix"
  ];
  
  services.conduwuit = {
    enable = true;

    settings.global = {
      server_name = "legusx.dev";
      allow_federation = false;
      allow_guest_registration = false;
      allow_registration = true;
      database_backend = "rocksdb";
    }
  }
  
  # services.nginx.virtualHosts."actual.legusx.dev" = {
  #   forceSSL = true;
  #   enableACME = true;
  #   serverAliases = ["actual.legusx.dev"];
  #   locations."/" = {
  #     proxyPass = "http://localhost:3004";
  #   };
  # };
}

