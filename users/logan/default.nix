{pkgs, ...}: {
  programs.zsh.enable = true;
  users.users.logan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "audio"];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDagHYo50nLw9/0VtVI2WbjOz6oz7dM+D6YMsR8nHXKqfhErQBleuvcwnnhLUr3LjsyF3RVtYUf+WYSFnwz+0ZBJNtMdqLJg0OsPXsM1ugbZlx4ZVNb1uMm2vZ1cer0DbDqAQsWwVsB3Z+E5VbUmcpRNFFbRhR9bd5/b3qPV+wHoGriAIkcFHcJ1HKTksHcFh27MYPqBkNcOkPjAPk1Vtr53v/4JK7Q7Z6CyJagw/axuNEmGlXDDvfN8vPfwxsR47VOjjqk9l1rhLODl+XLZKXtTbRr3+mKcVirBhMX0fPZ+FxVVraH741tlVuWrlyuECfPiVRLWo+TH/P4asxZxpnp9exXJ/miofPRJemtwm076MJm7Tw6EVlJynfY34iaA4ZWJCPOQCSIj4krzAcTf1OhxGsmlwoNpVecYoUVYaLZ6eiAhb1YGbm15vGwpf3IW1vPF+v09OiR+E5XbwOTCxY6Kk5XEgjqAjRENdvK/qP70XcjLt+5zThFh9FDS8e+Ry0= logan@ryzen-shine"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3K7k7X2/HL4uThxZJzWAGRanfBVJfyk/I5XNvV9zc3 logan@beccabook"
    ];
    initialPassword = "changemenow";
  };
  home-manager.users.logan = import ./home.nix;
}
