{
  config,
  pkgs,
  ...
}:
{
  #####################################################################
  # INFO: Requires rDNS to be configured, which is a later me problem #
  #####################################################################
  
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-24.05/nixos-mailserver-nixos-24.05.tar.gz";
      sha256 = "0clvw4622mqzk1aqw1qn6shl9pai097q62mq1ibzscnjayhp278b";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.legusx.dev";
    domains = ["legusx.dev"];

    loginAccounts = {
      "mealie@legusx.dev" = {
        hashedPasswordFile = "${config.sops.secrets."mail/mealie".path}";
        sendOnly = true;
      };
      "legusx@legusx.dev" = {
        hashedPasswordFile = "${config.sops.secrets."mail/legusx".path}";
        aliases = ["postmaster@legusx.dev" "abuse@legusx.dev"];
      };
    };

    forwards = {
      "logan@legusx.dev" = "loghenrie@gmail.com";
    };

    certificateScheme = "acme-nginx";
  }
}
