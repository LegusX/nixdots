# Seems to be more difficult than I had anticipated, might come back to later
{pkgs, inputs, ...}:
{
{
  services.matrix-tuwunel = {
    enable = true;

    settings = {
      server_name = "matrix.legusx.dev";
      new_user_displayname_suffix = "";

      
    };
  };

  networking.firewall.allowedTCPPorts = [ 8008 ];
}
}

