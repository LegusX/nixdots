{
  config,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        #extensions = with inputs.nur.repos.rycee.firefox-addons; [bitwarden ublock-origin];
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
      };
      # policies = {
      #   OfferToSaveLogins = false;
      # };
    };
  };
}
