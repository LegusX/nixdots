{config, ...}: {
  sops.secrets = {
    "mealie/smtp_user" = {};
    "mealie/smtp_pass" = {};
  };
  

  services.mealie = {
    enable = true;
    port = 9000;
    settings = {
      ALLOW_SIGNUP = "false";
      MAX_WORKERS = "1";
      TZ = config.time.timeZone;
      BASE_URL = "https://mealie.legusx.dev";
      DB_ENGINE = "postgres";
      POSTGRES_USER = "mealie";
      # Connect to pg over unix socket
      POSTGRES_URL_OVERRIDE = "postgresql://mealie:@/mealie?host=/run/postgresql";

      # SMTP setup
      SMTP_HOST = "smtp.gmail.com";
      SMTP_PORT = 587;
      SMTP_FROM_NAME = "Mealie";
      SMTP_AUTH_STRATEGY = "SSL";
      SMTP_FROM_EMAIL = config.sops.secrets."mealie/smtp_user";
      SMTP_USER = config.sops.secrets."mealie/smtp_user";
      SMTP_PASSWORD = config.sops.secrets."mealie/smtp_pass";
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
