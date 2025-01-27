{
  lib,
  ...
}:{
  options = {
    users.becca.enable = lib.mkEnableOption "Add becca user"
  };
  config = lib.mkIf users.becca.enable {
    users.users.becca = {
      isNormalUser = true;
      initialPassword = "changemenow";
    };

    home-manager = {
      users = {
        becca = import ../../becca.nix;
      };
    };
  }
}
