{pkgs, inputs, ...}:
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/actual.nix"
  ];
  
  services.actual = {
    enable = true;
    settings = {
      port = 3004;
    };
  };
  
  services.nginx.virtualHosts."actual.legusx.dev" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = ["actual.legusx.dev"];
    locations."/" = {
      proxyPass = "http://localhost:3004";
    };
  };
}
