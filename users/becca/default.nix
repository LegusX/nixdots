{
  lib,
  config,
  ...
}: {
  options = {
    users.becca.enable = lib.mkEnableOption "Add becca user";
  };
  config = lib.mkIf config.users.becca.enable {
    users.users.becca = {
      isNormalUser = true;
      initialPassword = "changemenow";
    };

    home-manager = {
      users = {
        becca = import ./home.nix;
      };
    };
  };
}
