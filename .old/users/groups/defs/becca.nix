{
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
