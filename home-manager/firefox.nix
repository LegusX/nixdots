{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        extensions = with config.nur.repos.rycee.firefox-addons; [bitwarden, ublock-origin];
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
        policies = {
          OfferToSaveLogins = false;
        };
      };
    }
  };
}
