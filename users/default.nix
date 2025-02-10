{lib, ...}: {
  imports = [
    ./logan
    ./becca
  ];

  users.becca.enable = lib.mkDefault false;
}
