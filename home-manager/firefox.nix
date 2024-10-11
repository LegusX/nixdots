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
          "extensions.autoupdate.enabled" = true;
          "extensions.installDistroAddons" = true;
          "extensions.webextensions.uuids" = {
            "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/" = "363fc941-6c8c-4ce6-a632-70b1227f359a";
            "https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager" = "4b1a6227-0b5e-4702-8b4e-abab47da06c2";
          };
        };
      };
      # policies = {
      #   OfferToSaveLogins = false;
      # };
    };
  };
}
