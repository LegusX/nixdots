{
  config,
  pkgs,
  ...
}: {
  sops.secrets.nextcloud-admin = {
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  services.nextcloud = {
    enable = true;
    hostName = "cloud.legusx.dev";
    package = pkgs.nextcloud29;

    # database.createLocally = true;
    maxUploadSize = "16G";
    https = true;

    config = {
      overwriteProtocol = "https";
      # dbtype = "pgsql";
      adminpassFile = "${config.sops.secrets.nextcloud-admin.path}";
      adminuser = "admin";
    };

    autoUpdateApps.enable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
    };
    extraAppsEnable = true;
  };
}