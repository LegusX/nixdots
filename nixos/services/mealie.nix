{config, ...}: {
  
  services.mealie = {
    enable = true;
    port = 9000;
    settings = {
      ALLOW_SIGNUP = "false";
      MAX_WORKERS = "1";
      TZ = config.time.timeZone;
      BASE_URL = "https://mealie.legusx.dev";
      DB_ENGINE = "postgres";
      # Connect to pg over unix socket
      POSTGRES_URL_OVERRIDE = "postgresql://mealie:@/mealie?host=/run/postgresql";
    };
  };

  services.nginx.virtualHosts."mealie.legusx.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.mealie.port}";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = ["mealie"];
    ensureUsers = [
      {
        name = "mealie";
        ensureDBOwnership = true;
      }
    ];
  };
}
