{
  config,
  pkgs,
  ...
}: {
  services.mealie = {
    enable = true;
    port = 9000;
    credentialsFile = config.sops.templates."mealie.env".path;
    package = pkgs.unstable.mealie;
    settings = {
      ALLOW_SIGNUP = "false";
      MAX_WORKERS = "1";
      TZ = config.time.timeZone;
      BASE_URL = "https://mealie.legusx.dev";

      # SMTP Setup
      SMTP_HOST = "smtp.gmail.com";

      ALEMBIC_CONFIG_FILE = "${config.services.mealie.package}/alembic.ini";

      DB_ENGINE = "postgres";
      POSTGRES_URL_OVERRIDE = "postgresql://mealie:@/mealie?host=/run/postgresql";
    };
  };

  sops = {
    secrets."mealie/smtp_pass" = {};
    secrets."mealie/smtp_user" = {};
    templates."mealie.env".content = ''
      SMTP_USER=${config.sops.placeholder."mealie/smtp_user"}
      SMTP_FROM_EMAIL=${config.sops.placeholder."mealie/smtp_user"}
      SMTP_PASSWORD=${config.sops.placeholder."mealie/smtp_pass"}
    '';
  };

  services.nginx.virtualHosts."mealie.legusx.dev" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = ["mealie.legusx.dev"];
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.mealie.port}";
    };
    locations."/cloak/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.keycloak.settings.http-port}/cloak/";
    };
  };

  # Can't make postgres work
  systemd.services = {
    mealie = {
      after = ["postgresql.service"];
      requires = ["postgresql.service"];
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
